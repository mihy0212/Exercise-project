<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>반짝 대기방s</title>

<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=0, user-scalable=no, target-densitydpi=medium-dpi" />
<!-- jQuery library -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>

<!-- Latest compiled and minified CSS -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">

<!-- Popper JS -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>

<!-- Latest compiled JavaScript -->
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>

<script src="../resources/scripts/json.min.js"></script>


<style>

	body {
		margin: 0;
	}
	
	div { text-align: center; padding-top:30px; }
	
	
	
	#over img {
		margin-left: auto;
		margin-right: auto;
		display: block;
	}
	
	
	.button-title {
	  background: #fff;
	  border: 3px solid #FE9191;
	  border-radius: 7px;
	  color: #FE9191;
	  font-size: 15px;
	  font-weight: bold;
	  margin: 0.3em auto;
	  padding: 2px 6px;
	  position: relative;
	  text-transform: uppercase;
	  width: 100%;
	}
		
	.button-general {
	  background: #FE9191;
	  border: 3px solid #fff;
	  border-radius: 7px;
	  color: #fff;
	  font-size: 15px;
	  font-weight: bold;
	  margin: 0.3em auto;
	  padding: 3px 9px;
	  position: relative;
	  text-transform: uppercase;
	  height: 40px;
	}
	
	.button-general {
	  background: #FE9191;
	  border: 3px solid #fff;
	  border-radius: 7px;
	  color: #fff;
	  font-size: 15px;
	  font-weight: bold;
	  margin: 0.3em auto;
	  padding: 3px 9px;
	  position: relative;
	  text-transform: uppercase;
	  height: 40px;
	}
	
	.wrap{
	     width: 1000px;
	     height: 300px;
	     overflow-x: scroll;
	     white-space:nowrap;
	   }
	   
	div#room-info-div.modal-body{
		text-align : left;
	}
	
	table#room-info-table th{
		width: 80px;
		height: 30px;
		border-right: 3px solid;
	}

	table#room-info-table td{
		padding-left: 15px;
	}

</style>

<!-- 로그인한사람의 id,닉네임,캐릭터코드 저장 -->
<sec:authentication property="principal.username" var="id"/>
<sec:authentication property="principal.m_nick" var="nick"/>
<sec:authentication property="principal.m_image_cd" var="image"/>

<script>
		$(function() { //페이지 로딩 완료 후 실행

			//로딩되자마자 아이디 입력받고 아작스로 세션에 저장.
			var usrId = "${id}";
			
			/* if(usrId==""){ //만약 세션에 id가 없으면 입력받아라.
				var id={ "id" : prompt("세션에 저장할 id 입력 : ")};
				
				$.ajax({
					url: "saveId",
					type:'GET',
					data: id,
					
					success: function(){
						alert("아이디 저장!");
					},
					error: function(){
						alert("아이디 저장 실패!");
					}
					
				});
			} */
			
			console.log("usrId : "+usrId);
			
			//채팅 전송버튼 눌렀을때
			$("body").on("click", "[id^=chat]", function() {

				send();

			});

			
				
			//신고모달에서 신고하기 버튼 눌렀을 때
			$("body").on("click", "[id^=doReport]", function() {

				var confirmStatus = confirm("정말로 신고 하시겠습니까?");

				if (confirmStatus) {
					
					var param = JSON.stringify($("#report-frm").serializeObject());
					
					$.ajax({
						url: "doReport",
						method:'post',
						dataType: "json",	//결과타입
						data: param,		//요청파라미터
						contentType: "application/json",
						//컨트롤러로 데이타 보낼때 제이슨이라는 것을 알려줘야함. 컨트롤러에는 담을 vo에@RequestBody붙여주고.
						success: function(){
							alert("신고 처리 되었습니다.");
						},
						error: function(){
							alert("신고 실패");
						}
						
					});
					
					$('#profile').modal('hide'); //프로필 모달창 까지 닫기

				} else {
					console.log("신고취소함");
				}

			});
			
			
			//프로필모달에서 강퇴 버튼 눌렀을 때
			$("body").on("click", "[id^=kickOut]", function() {

				var confirmStatus = confirm("정말로 강퇴 하시겠습니까?");

				if (confirmStatus) {
					
					alert("강퇴 완료.");
					console.log("강퇴했을때 처리할 곳");
					
					$('#profile').modal('hide'); //프로필 모달창 닫기

				} else {
					console.log("강퇴취소함");
				}

			});
			
			
			//참가취소 버튼 눌렀을때
			$("body").on("click", "[id^=cancelJoin]", function() {

				//웹소켓으로 방정보 업데이트(인원수,방상태), 본인프로필 화면에서 삭제, 활동히스토리 DELETE, 본인은 목록으로 돌아가게.
				var confirmStatus = confirm("정말로 반짝 참여를 취소 하시겠습니까?");

				if (confirmStatus) {
					
					var sgNum = ${sgroup.sg_num};
					var sgCnt = ${sgroup.sg_now_cnt};
					
					alert(usrId);
					
					deleteProfile();
					
					if(sgCnt>1){ //일단 sgCnt가 1이상인 방만 카운트 - 되게 여기다 해놓음.
						location.href='cancelJoin?m_id='+usrId+'&sg_num='+sgNum;
					}
					
					alert("참가 취소 완료.");
					
				} else {
					console.log("참가취소 취소함");
				}
				//그리고 방장이 빠져나가면 방 삭제되게.

			});
			
			
		});
</script>

</head>
<body>
<!-- 버튼영역 위(프로필까지)의 div 시작 -->
    <div style="padding-top:0px;">
    
    <input type="hidden" id="s_id" value='${id}'>
    <input type="hidden" id="s_nick" value='${nick}'>
    <input type="hidden" id="s_character" value='${image}'>
    
	<!-- 방제 -->
    	<div style="background-color: #FE9191; text-align: left; padding-left:20px; color: #fff;"> 
      		<span id="title">${sgroup.sg_name }</span><br />
      		<span id="endDate"><fmt:formatDate value="${sgroup.sg_end_dttm }" pattern="MM/dd" /></span>
      		<span id="endTime"><fmt:formatDate value="${sgroup.sg_end_dttm }" pattern="a hh:mm" /></span>
      		<span style="padding-left:78%"><button data-toggle="modal" data-target="#room-info"
      					style="background-color:#FFC0C0;" class="button-general">방 정보</button></span>
      		
    	</div>
    	
	<!-- 채팅 -->	
    	<div style="padding-top:0px; padding-bottom:20px">
    		<div>
      			<textarea id="messageWindow" style="font-size:15px; background-color:#FE9191;border-radius:5px;border:3px double #FFF;
      							padding:10px; resize:none; width:80%; height:300px;" readonly="readonly"></textarea>
      			<div style="padding-top:10px;">
      				<span style="padding-left:5px; padding-right:3px; vertical-align: middle;">
      					<textarea id="inputMessage" style="font-size:15px; border-radius:5px; padding:10px; resize:none; width:65%; height:70px; ">입력하세요</textarea>
      				</span>
      				<span style="vertical-align:middle;">
      					<button id="chat" class="button-general">전송</button>
      				</span>
      			</div>
    		</div>
    	</div>
    	
    	
	<!-- 참여자 프로필 -->
     	<div id="profileList" style="border-top: thick double #FE9191; border-bottom: thick double #FE9191; padding-top:15px; padding-bottom:15px;">
				<!-- foreach로 프로필 읽어와서 붙이기(memlist.어쩌구) -->
        		<%-- <span id="cancel" data-toggle="modal" data-target="#profile" style="font-size:13px; padding:10px; display:inline-block;"> <!-- inline-block : span태그에 꼭맞게 만들어줌 -->
          			<img style="padding-bottom:5px;" width="65px" height="65px"
          							src="${pageContext.request.contextPath }/resources/images/jey/trainer-1.jpg" class="rounded-circle">
        			<br />사람1
        		</span> --%>
        		<!-- 참여 멤버 프로필사진 불러오기(캐릭터, 닉네임) -->
        		<c:forEach var="member" items="${memlist}">
				    <span id="${member.m_id}" data-toggle="modal" data-target="#profile" style="font-size:13px; padding:10px; display:inline-block;"> <!-- inline-block : span태그에 꼭맞게 만들어줌 -->
	          			<img style="padding-bottom:5px;" width="65px" height="65px"
	          							src="${pageContext.request.contextPath }/resources/images/Characters/${member.m_image_cd}.gif" class="rounded-circle">
	        			<br />${member.m_nick}
        			</span>
				
				</c:forEach>

    	</div>
    			
    </div> 													
<!-- 버튼영역 위(프로필까지)의 div 끝 -->

<!-- 버튼영역 시작(아직 아무 기능 없음) -->														
    <div style="padding-bottom:30px">
      	<button class="button-general">참가인증</button>&nbsp;<button id="cancelJoin" class="button-general">참가취소</button>&nbsp;
      	<button class="button-general">공유</button>&nbsp;<button class="button-general">목록</button>
    </div>
<!-- 버튼영역 끝 -->




<!-- 모달시작 -->
<!-- 프로필 모달 --><!-- 프로필 모달 --><!-- 프로필 모달 --><!-- 프로필 모달 --><!-- 프로필 모달 --><!-- 프로필 모달 --><!-- 프로필 모달 -->
<div class="container">
	<div class="modal fade" id="profile">
		<div class="modal-dialog">
			<div class="modal-content">
      
<!-- Modal Header -->
				<div class="modal-header">
					<h4 class="modal-title">프로필</h4>
					<button type="button" class="close" data-dismiss="modal">&times;</button>
				</div>
        
<!-- Modal body -->
				<div class="modal-body">
					해당 회원 정보
				</div>
        <!-- data-dismiss="modal" id="report" -->
<!-- Modal footer -->
				<div class="modal-footer">
					<button type="button" class="button-general" data-toggle="modal" data-target="#report-user">신고</button>
					<button style="background: crimson;" id="kickOut" type="button" class="button-general">강퇴</button> <!-- 얘는 방장만 보이게 -->
				</div>
        
			</div>
		</div>
	</div>
</div>


<!-- 방정보 모달 --><!-- 방정보 모달 --><!-- 방정보 모달 --><!-- 방정보 모달 --><!-- 방정보 모달 --><!-- 방정보 모달 --><!-- 방정보 모달 -->
<div class="container">
	<div class="modal fade" id="room-info">
		<div class="modal-dialog">
			<div class="modal-content">
      
<!-- Modal Header -->
				<div class="modal-header">
					<h4 class="modal-title">${sgroup.sg_name}</h4>
					<button type="button" class="close" data-dismiss="modal">&times;</button>
				</div>
        
<!-- Modal body -->
			<!-- 방정보 -->
				<div id="room-info-div" class="modal-body">
					
					<table id="room-info-table">
						<tr>
							<th>운동 </th><td> ${sgroup.sports1_cd}</td>
						</tr>
						<tr>
							<th>일시 </th><td> <fmt:formatDate value="${sgroup.sg_end_dttm }" pattern="yyyy/MM/dd a hh:mm" /></td>
						</tr>
						<tr>
							<th>장소 </th><td> ${sgroup.sg_location}</td>
						</tr>
						<tr>
							<th>참가정보 </th><td> ${sgroup.gender_cd} ${sgroup.age_range}</td>
						</tr>
						<tr>
							<th>인원 </th><td> ${sgroup.sg_end_cnt} 명중 ${sgroup.sg_now_cnt} 명 참가</td>
						</tr>
						<tr>
							<th>숙련도 </th><td> ${sgroup.skill_cd}</td>
						</tr>
						<tr>
							<th>상태 </th>
							<td>
								<c:set var="now_cnt" value="${sgroup.sg_now_cnt}" />
								<c:set var="end_cnt" value="${sgroup.sg_end_cnt}" />
								<c:set var="sg_option" value="${sgroup.sg_option}" />
								<c:choose>
									<c:when test="${now_cnt eq end_cnt}">
										참가대기
									</c:when>
									<c:otherwise>
										참여가능
									</c:otherwise>
								</c:choose>
							</td>
						</tr>
						<c:if test="${not empty sg_option}">
							<tr>
								<th>옵션 </th><td> ${sgroup.sg_option}</td>
							</tr>
						</c:if>
					</table>
				</div>
        
<!-- Modal footer -->
				<div class="modal-footer">
					<button type="button" class="button-general" data-dismiss="modal">닫기</button>
				</div>
        
			</div>
		</div>
	</div>
</div>


<!-- 프로필 모달 내 신고모달 --><!-- 프로필 모달 내 신고모달 --><!-- 프로필 모달 내 신고모달 --><!-- 프로필 모달 내 신고모달 --><!-- 프로필 모달 내 신고모달 -->
<div class="container">
	<div class="modal" id="report-user">
		<div class="modal-dialog">
			<div class="modal-content">
      
<!-- Modal Header -->
				<div class="modal-header">
					<h4 class="modal-title">신고</h4>
					<button type="button" class="close" data-dismiss="modal">&times;</button>
				</div>
        
<!-- Modal body -->
				<form id="report-frm">
				<div id="report-div" class="modal-body">
					<table id="report-table">
						<tr align="left">
							<th width="30px" style="padding-left:20px;">id</th><th>신고사유</th>
						</tr>
						<tr>
							<td width="48%" align="left" style="padding:0 20px;"><input name="tr_mid" style="font-size:15px; border-radius:5px; width:100%;" type="text"></td>
							<td width="52%">
								<select name="tr_reason_cd" style="width:92%" class="form-control">
								  <option value="T01">욕설 및 비방</option>
								  <option value="T02">성희롱</option>
								  <option value="T03">권리 침해</option>
								  <option value="T04">폭력적</option>
								  <option value="T05">테러 조장</option>
								</select>
							</td>
						</tr>
						<tr style="padding-top:20px"><td style="padding-top:20px; align-content: center;" colspan="2"><textarea style="font-size:15px; border-radius:5px; padding:10px;
      							resize:none; width:90%; height:200px;">신고내용</textarea></td></tr>
					</table>
				</div>
        
<!-- Modal footer -->
				<div class="modal-footer">
					<button id="doReport" type="button" class="button-general" data-dismiss="modal">신고하기</button>
					<button type="button" class="button-general" data-dismiss="modal">취소</button>
				</div>
				</form>
        
			</div>
		</div>
	</div>
</div>

<!-- 웹소켓 채팅 -->
<script type="text/javascript">

 var textarea = document.getElementById("messageWindow"); 
 var webSocket = new WebSocket('ws://localhost/gca/broadcast.do'); 
 var inputMessage = document.getElementById('inputMessage');
 
 webSocket.onerror = function(event) { onError(event) };
 webSocket.onopen = function(event) { onOpen(event) };
 webSocket.onmessage = function(event) { onMessage(event) };
 
 function onMessage(event) { //명령어에따라 다른 동작이 되도록 else문으로 명령어 더 추가해서 할 수 있음.(핸들러에도 같이 추가해야함.)
	var result = JSON.parse(event.data);
	if(result.cmd == "join") { //방에 들어온경우(웹소켓 연결된 경우)
		//var img = document.getElementById('s_character').value;
		//var nick = document.getElementById('s_nick').value;
		//var id = document.getElementById('s_id').value;
		var img = "${image}"; //이거갖고 뿌려줄려면 result로 받은 값으로 해야함,........
		var nick = "${nick}";
		var id = "${id}";
		
		var param = {"img":img};
		
		console.log("id : "+id);
		console.log("nick : "+nick);
		console.log("img : "+img);
		
		//이미지 영어이름 갖고오는 ajax(웹소켓에서 처리하는 방향 알아보기.)
		/* $.ajax({
			url: "returnImage",
			type:'GET',
			async:false,
			data: param,
			//dataType: "Json",
			
			success: function(data){
				console.log(data);
				img=data;
			},
			error: function(){
				
			}
			
		}); */
		
		//프로필 붙여주기~~
		$span = $("<span data-toggle='modal' data-target='#profile' style='font-size:13px; padding:10px; display:inline-block;'>");
		$span.attr("id","${id}");
		$img = $("<img style='padding-bottom:5px;' width='65px' height='65px'>");
		$img.attr({"src": "${pageContext.request.contextPath }/resources/images/Characters/"+img+".gif"});
		$text = "${nick}";
		
		$span.append($img);
		$span.append('<br />');
		$span.append($text);
		
		textarea.value += result.msg + "\n";
		$('#profileList').append($span);
	 	
	}
	else if( result.cmd = "msg") { //메세지 전송하는 경우
		textarea.value += result.msg + "\n";
	}
	else if( result.cmd = "cancelJoin") { //참가취소 누르고 웹소켓 거쳐왔을때.
		var person = result.id;
		var result = JSON.parse(event.data);
		console.log("person:"+person);
		//프로필 삭제
		$('#'+person).remove();
		textarea.value += result.msg + "\n"; //채팅방에 나갔다고 표시.
	}
	  
	chatAreaScroll(); 
 }
 
 function onOpen(event) { //이미 참여된방에 참여인지 새로 참여인지 구분해서 새로참여만 참가하셨습니다 띄우고 프로필 붙이기.
	msg = {
		cmd : "join",
		id : "${id}",
		msg : "<"+"${id}"+"님이 참가하셨습니다.>"
		//여기에 아이디 붙여서 추가하면 될듯. 근데 새로고침해도 이게 뜨는것은 막아야함.
	}				//msg의 id 넣는 부분을 ${sessionScope.id}말고 json의 id로 가져오는 방법은 없을까
	webSocket.send(  JSON.stringify( msg )   );
 }
 function onError(event) { 
	console.log(event); 
 	alert(event.data); 
 }
 
 //메세지 전송
 function send() { 
	 msg = {
		 cmd : "msg",
		 id : "${id}",
		 msg : inputMessage.value
	 }
	//textarea.value += "나 : " + inputMessage.value + "\n"; 
	webSocket.send(  JSON.stringify( msg )   ); 
	inputMessage.value = ""; 
 } 
 
 //나갔을때 참여자 칸에서 프로필 삭제
 function deleteProfile() { 
	 msg = {
		 cmd : "cancelJoin",
		 id : "${id}",
		 msg : "<"+"${id}"+"님이 나가셨습니다.>"
	 }
	webSocket.send(  JSON.stringify( msg )   );
	
	
 }

 
 //채팅치면 스크롤바 내려가게 하기.
 function chatAreaScroll() {
	//using jquery
	/* var textArea = $('#messageWindow');
	textArea.scrollTop( textArea[0].scrollHeight - textArea.height() );
	textArea.scrollTop( textArea[0].scrollHeight); */
	//using javascript
	var textarea = document.getElementById('messageWindow');
	textarea.scrollTop = textarea.scrollHeight;
}
</script>
    
</body>
</html>