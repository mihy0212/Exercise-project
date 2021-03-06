<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="description" content="">
<meta name="author" content="">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">
<!-- Latest compiled and minified CSS -->
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
<!-- jQuery library -->
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<!-- Popper JS -->
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
<!-- Latest compiled JavaScript -->
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>


<!-- 꼭있어야함 -->
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
<script src="https://use.fontawesome.com/releases/v5.2.0/js/all.js"></script>

<sec:authentication property="principal.m_image_cd" var="image"/>

<!--json할때 필요  -->
<title>회원정보 조회</title>

</head>
<body>

	<div>
		<div class="col-50">
			<div class="card">
				<div class="card-header" style="background-color: #FEBABA;">
					회원정보 조회</div>
				<div class="card-body">
					<form name="form1" method="post">
						<table style="margin-left: auto; margin-right: auto;"   >
							<tr>
								<td rowspan="10" width="100px"><img style="padding-bottom:5px; border-spacing: 10px;"  width="65px" height="65px"src="${pageContext.request.contextPath }/resources/images/Characters/${dto.m_image_cd}.gif"></td>				
							</tr>
							<tr>
								<td width="100px">아이디</td>
								<td>${dto.m_id}</td>
							</tr>
							<tr>
								<td width="100px">이름</td>
								<td>${dto.gender_cd}</td>
							</tr>
							<tr>
								<td width="100px">성별</td>
								<td>${dto.m_name}</td>
							</tr>
							<tr>
								<td width="100px">계정상태</td>
								<td>${dto.m_status_cd}</td>
							</tr>
							<%-- <tr>
								<td>닉네임</td>
								<td>${dto.m_nick}</td>
							</tr> --%>
							<tr>
								<td width="100px">레벨</td>
								<td><img style="padding-bottom:5px;" width="30px" height="30px"src="${pageContext.request.contextPath }/resources/images/level/${dto.m_level_cd}.png"></td>
							</tr>

							<tr>
								<td width="100px">주소</td>
								<td>${dto.m_location}</td>
							</tr>

							<tr>
								<td width="100px">이메일주소</td>
								<td>${dto.m_email}</td>
							</tr>

							<tr>
							<tr>
								<td colspan="2" align="center"></td>
							</tr>
						</table>
						<br>

					</form>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
