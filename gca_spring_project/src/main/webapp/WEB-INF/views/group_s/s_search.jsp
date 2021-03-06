<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>함께 운동할 상대를 찾아보세요!</title>

	<!-- private : icon 1 & slide 2 & alert+confirm -->
	<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.7.0/css/all.css">
	<link rel="stylesheet" href="../resources/css/mihy/swiper.min.css">
	<script src="../resources/js/mihy/swiper.min.js"></script>
    <link href="../resources/css/mihy/notiflix-1.9.1.min.css" rel="stylesheet">
	<script src="../resources/js/mihy/notiflix-1.9.1.min.js"></script>

<script>
	var mgrant = "<sec:authentication property='principal.m_status_cd'/>";
</script>

	<!-- private : Description Action -->
	<script type="text/javascript" src="../resources/js/mihy/s_search.js"></script>
	<link rel="stylesheet" href="../resources/css/mihy/search.css">

</head>


<body>

<nav class="fixed-top">
<div align="center" class="nav_title mt-2 mb-2"><h4>함께 할 반짝 찾기</h4></div>

<!-- 계정 상태가 활동중인 사람들만 버튼 보임 -->
<sec:authentication property='principal.m_status_cd' var='mgrant'/> <!-- 변수에 이 회원의 계정상태 대입 -->
<c:if test="${mgrant == 'M01'}"> <!-- 계정상태가 활동중이라면 버튼 띄움 -->
	<button class="btn btn-info create_room mt-1 ml-3 mr-3 shadow-sm" style="width:90%;">반짝 방 생성하기</button>
</c:if>

<form action="getSgList" name="searchSport" id="searchSport" method="post">
<div class="swiper-container">
	<div class="swiper-wrapper">
		<div class="swiper-slide p-2"><i class="fas fa-star-of-david pr-2"></i>전체</div>
		<c:forEach items="${sports_list }" var="list">
			<div class="swiper-slide p-2" id="${list.cd_id }" data-sports="${list.cd_id }">${list.cd_etc}${list.cd_name }</div>
		</c:forEach>
	</div>
</div>
<input type="hidden" name="key" id="key" value="${sgroup.key}">
<input type="hidden" name="keyval" id="keyval" value="${sgroup.keyval}">
</form>
</nav>

<table class="table table-striped" id="tb1"  style="margin-top:160px">
	<c:forEach items="${ list }" var="sg">
	<tr class="tr ${sg.sg_num}">
		<td class="td1">
			<p class="content p9"><span class="badge badge-pill badge-light shadow-sm">${sg.dis }</span></p>
			<p class="content p1">
				<c:forEach items="${sports_list }" var="list">
				<c:choose>
				<c:when test="${sg.sports1_cd == list.cd_id}">
					<c:if test="${list.cd_etc != null}">${list.cd_etc}</c:if>
					<c:if test="${list.cd_etc == null}">
						<img src="../resources/images/mihy/badminton-black.png" width="32px">
					</c:if>
				</c:when>
				</c:choose>
				</c:forEach>
			</p>
			<p class="content p2"><span class="badge badge-dark">${sg.skill_cd }▲</span></p>
		</td>
		
		<td class="td2">
			<p class="content p5">
				<span class="badge badge-warning mr-1 ml-2">
					<font color="red" class="sg_now_cnt">${sg.sg_now_cnt }</font>
					&nbsp;/&nbsp;<font color="gray" class="sg_end_cnt">${sg.sg_end_cnt }명</font>
				</span>
				<span class="badge badge-info mr-2">${sg.gender_cd }</span>${sg.age_range }
			</p>
			<p class="content p4">${sg.sg_name }</p>
			<p class="content p3">${sg.sg_location }</p>
			<input type="hidden" class="dis" value="${sg.dis }">
		</td>
		
		<td class="td3" align="center">
			<input type="hidden" class="dttm" value="${sg.sg_end_dttm }">
			<p class="content p6"><fmt:formatDate value="${sg.sg_end_dttm }" pattern="yy.MM.dd(E)" /></p>
			<p class="content p7"><fmt:formatDate value="${sg.sg_end_dttm }" pattern="ahh:mm" /></p>
			<p class="content p8"></p>
			<c:if test="${sg.m_id != null}">
				<img class="proimg" src="${pageContext.request.contextPath }/resources/images/jey/C01.png">
			</c:if>
		</td>
		
	</tr>
	</c:forEach>
</table>

</body>
</html>
