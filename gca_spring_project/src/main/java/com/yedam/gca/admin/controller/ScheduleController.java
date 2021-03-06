 package com.yedam.gca.admin.controller;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

import org.apache.commons.io.IOUtils;
import org.apache.http.HttpResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.yedam.gca.admin.service.AdminService;
import com.yedam.gca.common.bootpay.BootpayApi;
import com.yedam.gca.common.bootpay.request.Cancel;

@Component
public class ScheduleController {

	@Autowired
	AdminService service;

	static BootpayApi api;
	
	
	/************* 수림 ******************
	 * 1. 사용자 실패한 챌린지 상태 '실패'로 변경; 성공은 인증시 디비단에서 적용 (매일 an 0:00) - 2020.01.27 추가
	 * 
	 * 2. 부트페이 서버 전송용 토큰 갱신 (매일 am 0:05) - 토큰 생성 후 30분 이후 소멸
	 * 		2-1. 부트페이 서버 인증용 토큰 받기
	 * 3. 부분환불처리 (매일 am 0:05)
	 * 		3-1  부분환불정보 부트페이 서버로 전송 
	 * 		3-2  부분환불 완료시 해당 정보 Money 테이블에 업데이트
	 * 4. 전액환불처리 (매일 am 0:10)
	 * 		4-1 전액환불정보 부트페이 서버로 전송 
	 * 		4-2 전액환불 완료시 해당 정보 Money 테이블에 업데이트
	 * 
	 */
	
	// 1. 사용자 실패한 챌린지 상태 '실패'로 변경 (성공은 인증시 디비단에서 적용)
	@Scheduled(cron = "0 0 0 * * * ")
	public void updateFailChallengeStatus() {
		service.updateFailChallengeStatus();
	}
	
	// 2. 부트페이 서버 전송용 토큰 갱신 (매일 am 0:05) - 토큰 생성 후 30분 후 소멸
	@Scheduled(cron = "0 5 0 * * * ")
	public void bootpay() throws InterruptedException {
	Map<String, String> bootpay = service.getBootpayInfo();
	String id = bootpay.get("id");
	String key = bootpay.get("key");		
	
		
	 api = new BootpayApi( 
			 		id, 		// REST용 Application ID
			 		key 		// 프로젝트의 Private KEY
		);
	
	 	int gap = 1000 * 60 * 5;    //  부분환불 - 전액환불 사이 쉬는시간 (디폴트 5분)
	 	
	 	getToken();  				// 1. 토큰 갱신
	 	partialRefund();			// 2. 부분환불
	 	
	 	Thread.sleep(gap); 			// 5분 휴식
	 	
	 	fullRefund();				// 3. 전액환불처리 (am 0:10)
	}
	
	// 2-1. 부트페이 서버 인증용 토큰 받기
	public void getToken() {
		
        try {
            api.getAccessToken();
        } catch (Exception e) {
            e.printStackTrace();
        }
	}
	
	
	/* 3. 부분환불 진행  
	 * 
	 * 스페셜챌린지 실패한 사용자의 경우 <마감기간 익일> 전체 결제금액의 일부를 부분환불 받는다 
	 * 부분환불은 마감기간 익일 진행 (디폴트 am 0:05)
	 * 환불완료시, Money 테이블에 부분환불완료 정보 업데이트
	 */
	// 3-1 부분환불정보 부트페이 서버로 전송 (매일 am 0:05)
	public void partialRefund() {
		
		List<Map<String, Object>> receipt = service.getPartialRefundList();		

		for (Map<String, Object> list : receipt) {
			
			double percent = 0.8;  // 환불받을 비율 (0.1 ~~ 1.0) 기본 80% (0.8)
			int refund = (int)(((BigDecimal) list.get("money_deposit")).doubleValue() * percent ) ;   // 부분환불 받을 금액
			String receiptId = (String) list.get("money_moid");		// 각 결제별 고유번호 
						
			Cancel cancel = new Cancel();
			cancel.price = refund;				// api에 환불금액을 싣는다
			cancel.receipt_id = receiptId;		// api에 결제 고유번호를 싣는다
			cancel.name = "운영자";
			cancel.reason = "챌린지 실패 - 부분환불";

			try {
				HttpResponse res = api.cancel(cancel);
				String str = IOUtils.toString(res.getEntity().getContent(), "UTF-8");
				System.out.println(str + "!! 부분환불서버전송 !!");
				updatePartialRefundList();   // 부분환불완료 대상이 있으면 2-2에서 디비 업데이트
			} catch (Exception e) {
				e.printStackTrace();
			}
		}//
	}

	// 3-2 부분환불 완료시 해당 정보 Money 테이블에 업데이트
	public void updatePartialRefundList() {
		service.updatePartialRefundList();
	}

	
	/* 4. 전액환불 진행  
	 * 
	 * 스페셜챌린지 성공한 사용자는 <성공 익일> 참가금을 전액환불 받는다
	 * 부분환불은 마감기간 익일 진행 (디폴트 am 0:10)
	 * 환불완료시, Money 테이블에 전액환불완료 정보 업데이트
	 */
	
	
	// 4-1 전액환불정보 부트페이 서버로 전송 (매일 am 0:10)
	public void fullRefund() {
		
		List<Map<String, Object>> receipt = service.getFullRefundList();		
		for (Map<String, Object> list : receipt) {
			
			int refund = ((BigDecimal) list.get("money_deposit")).intValue() ;  	//환불받을 금액
			String receiptId = (String) list.get("money_moid");		// 각 결제별 고유번호 
			
			Cancel cancel = new Cancel();
			cancel.price = refund;				// api에 환불금액을 싣는다
			cancel.receipt_id = receiptId;		// api에 결제 고유번호를 싣는다 
			cancel.name = "운영자";
			cancel.reason = "챌린지 성공 - 전체환불";

			try {
				HttpResponse res = api.cancel(cancel);
				String str = IOUtils.toString(res.getEntity().getContent(), "UTF-8");
				System.out.println(str + "!! 전체환불서버전송  !!");
				updateFullRefundList();  // 전체환불완료 대상이 있으면 3-2에서 디비 업데이트
			} catch (Exception e) {
				e.printStackTrace();
			}
		}//
	}
	
	//4-2 전액환불 완료시 해당 정보 Money 테이블에 업데이트
	public void updateFullRefundList() {
		service.updateFullRefundList();
	}
}
