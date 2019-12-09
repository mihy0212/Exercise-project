$(document).ready(function(){
	
	$(window).scroll(function(){
		if(Math.floor($(window).scrollTop()) == $(document).height() - $(window).height()){
			alert("페이지 끝");
		}
	});
	
	var swiper = new Swiper('.swiper-container', {
		slidesPerView: 'auto',
		centeredSlides: false,
		spaceBetween: 30,
		grabCursor: true
	});
	
	$('.create_room').on('click', function(){
		location.href='createRoomForm';
	});
	
	p8();
	setInterval(p8,1000);
	
	$('.table').on('click', '.tr', move_room);


});

//남은 시간 계산
function p8(){
	var now = new Date().getTime();
	for(var i=0; i< $('.dttm').length; i++){
		var dttm = $('.dttm').eq(i).val();
		
		var year = dttm.substring(0,4);
		var month = dttm.substring(5,7)-1;
		var day = dttm.substring(8,10);
		var hour = dttm.substring(11,13);
		var min = dttm.substring(14,16);
	
		var countDownDate = new Date(year, month, day, hour, min, 0, 0).getTime();
		var distance = countDownDate - now;
		console.log(distance)
		var d = Math.floor(distance / (1000 * 60 * 60 * 24));
		var h = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60)); 
		var m = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60)); 
		var s = Math.floor((distance % (1000 * 60)) / 1000);
		
		if(d<0){
			$('.p8').eq(i).html("<span class='badge badge-pill badge-secondary'><font color='white'><b>마감</b></font></span>");
		} else if(d<1 && h<1 && m<1){
			$('.p8').eq(i).html("<span class='badge badge-pill badge-danger'><font color='white'><b>"+s+"초 남음</b></font></span>");
		} else if(d<1 && h<1){
			$('.p8').eq(i).html("<span class='badge badge-pill badge-danger'><font color='white'><b>"+m+"분"+s+"초 남음</b></font></span>");
		} else if(d<1){
			$('.p8').eq(i).html("<span class='badge badge-pill badge-danger'><font color='white'><b>"+h+"시간 남음</b></font></span>");
		} else {
			$('.p8').eq(i).html("<span class='badge badge-pill badge-success'><font color='white'><b>"+d+"일 남음</b></font></span>");
		}
	}
}

function move_room(){
	
	$.ajax({
		url: "sgIn",
		dataType: "json",
		contentType: "application/json",
		success: function
	});
	
	var sg_num = $(this).attr("class").substring(3);
	var sg_now_cnt = $(this).find('font.sg_now_cnt').text();
	var sg_end_cnt = $(this).find('font.sg_end_cnt').text().substring(0,1);
	console.log(sg_end_cnt)
	var sg_dttm = $(this).find('p.p8').text();
	//console.log(sg_dttm)
	
	if(sg_dttm == "마감"){
		alert("마감 시간이 초과되어 참여하실 수 없습니다.");
		return false;
	}
	
 	if(sg_now_cnt < sg_end_cnt){
		$.ajax({
			url: "sgNowCnt/" + sg_num,
			dataType: "json",
			contentType : "application/json",
			success: move_room_handler
			});
	} else if(sg_now_cnt >= sg_end_cnt){
		alert("모집 인원이 초과되어 참여하실 수 없습니다. 인원 변동이 발생하면 참여해 주세요.");
		return false;
	}
}


function move_room_handler(result){
	if(result.sg_now_cnt >= result.sg_end_cnt){
		alert("모집 인원이 초과되어 참여하실 수 없습니다. 인원 변동이 발생하면 참여해 주세요.");
		return false;
	} else {
		var con = confirm("선택한 반짝에 참여하시겠습니까?");
		if(con){
			location.href='getRoomInfo2?sg_num='+result.sg_num+'&sg_now_cnt='+result.sg_now_cnt;	
		} else return false;
	}
}