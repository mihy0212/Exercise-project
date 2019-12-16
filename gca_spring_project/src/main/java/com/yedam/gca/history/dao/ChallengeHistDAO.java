package com.yedam.gca.history.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.yedam.gca.history.vo.ChallengeHistVO;

@Repository
public class ChallengeHistDAO {
	
	@Autowired
	SqlSessionTemplate mybatis;
	
	
	//진영
		// 챌린지 히스로리 목록 출력
	
	public List<ChallengeHistVO> getChallengehtList(ChallengeHistVO vo) {
		return mybatis.selectList("ChallengeDAO.getChallengehtList");
	}
}