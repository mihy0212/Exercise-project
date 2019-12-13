package com.yedam.gca.admin.controller;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.yedam.gca.admin.service.AdminService;
import com.yedam.gca.board.vo.QnaBoardVO;
import com.yedam.gca.challenge.vo.ChallengeVO;
import com.yedam.gca.common.Paging;
import com.yedam.gca.member.controller.MembersController;
import com.yedam.gca.member.vo.MembersVO;

@Controller
public class AdminController {
// 1-1챌린지 관리 페이지		1-2챌린지 등록
// 2매출 페이지
// 3-1통계 페이지 	3-2반짝 운동별 통계 	3-3동호회 매치 운동별 통계 	 3-4연령대 및 운동(반짝)성별 통계 	3-5지역별 반짝 운동 통계

	@Autowired
	AdminService adminService;

	// 지원 1-3번
	// 1-1. 챌린지 관리 페이지
	@RequestMapping("/admin/challenge")
	public String adminChallenge() {
		return "/admin/admin_challenge_list";
	}

	// 1-2. 챌린지 목록
	@ResponseBody
	@RequestMapping("ajax/challengeList")
	public List<ChallengeVO> challengeList() {
		return adminService.challengeList();
	}

	// 1-3. 챌린지 등록
	@ResponseBody
	@RequestMapping(value="ajax/createChallenge", consumes="application/json")
	public ChallengeVO createChallenge(@RequestBody ChallengeVO vo){
		adminService.createChallenge(vo);
		return vo;
	}
	
	// 1-4. 챌린지 진행 현황
	@ResponseBody
	@RequestMapping("/ajax/challenge/going")
	public Map<String, Object> challengeGoing(@RequestParam String cl_num) {
		int num = Integer.parseInt(cl_num);
		return adminService.challengeGoing(num);
	}

	// 2. 매출 페이지
	@RequestMapping("/admin/sale")
	public String adminMoney() {
		return "/admin/admin_bank";
	}

	// 3-1. 통계 페이지
	@RequestMapping("/admin/chart")
	public String adminChart() {
		return "/admin/admin_chart";
	}

	// 3-2. 통계 -> 반짝 운동별 통계
	@ResponseBody
	@RequestMapping("/ajax/chart/sgroup")
	public List<Map<String, Object>> chartSgroup() {
		return adminService.chartSgroup();
	}

	// 3-3. 통계 -> 동호회 매치 운동별 통계
	@ResponseBody
	@RequestMapping("/ajax/chart/bgroup")
	public List<Map<String, Object>> chartBgroup() {
		return adminService.chartBgroup();
	}

	// 3-4. 통계 -> 연령대 및 운동(반짝)성별 통계
	@ResponseBody
	@RequestMapping("/ajax/chart/gender")
	public Map<String, List<Map<String, Object>>> chartGender() {
		return adminService.chartGender();
	}

	// 3-5. 통계 -> 지역별 반짝 운동 통계
	@ResponseBody
	@RequestMapping("/ajax/chart/city")
	public List<Map<String, Object>> chartCity() {
		return adminService.chartCity();
	}

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	// 진영
	 private static final Logger logger = LoggerFactory.getLogger(MembersController.class);
	 // **전체조회
		@RequestMapping("/admin/getUserList")
	public String getUserList1(Model model, MembersVO vo) {
		model.addAttribute("userList", adminService.getUserList(vo));
		return "/admin/userList";
	}
		
		

	//03 회원 상세정보 조회
		  @RequestMapping(value="/admin/viewMember", method=RequestMethod.GET)
    public ModelAndView viewMember(@RequestParam String m_id)throws Exception{
    	// 모델(데이터)+뷰(화면)를 함께 전달하는 객체
		ModelAndView mav = new ModelAndView();
        // 회원 정보를 model에 저장
		mav.addObject("dto", adminService.viewMember(m_id));
       /// 뷰의 이름
		mav.setViewName("/notiles/admin/admin_user_view");
		logger.info("mav:", mav);
       // member_view.jsp로 포워드
		return mav;
    }
		  
		  
		  
		// 단건조회
		  @ResponseBody  
		  @RequestMapping(value = "member/{m_id}", method = RequestMethod.GET) public
		  MembersVO viewMember(@PathVariable String m_id, MembersVO vo) throws Exception {
			  vo.setM_id(m_id);
			  return adminService.viewMember(m_id); }
		  
    

    

	// **전체조회
	@ResponseBody
	@RequestMapping(value = "/ajax/getUserList")
	public List<MembersVO> getUserList(Model model, MembersVO vo) {
		return adminService.getUserList(vo);
	}


	

	//**관리자 유저 삭제
	@ResponseBody
	@RequestMapping(value = "/ajax/members/{m_id}", method = RequestMethod.DELETE)
	public String deleteUser(@PathVariable String m_id, MembersVO vo) {
		vo.setM_id(m_id);
		adminService.deleteUser(vo);
		return m_id;
	}


}
