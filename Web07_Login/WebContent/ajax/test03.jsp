<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<h1>form에 입력한 내용을 Ajax요청으로 전송하는 예제</h1>
<form action="insert.jsp" method="post" id="myForm">
	<input type="text" name="email" placeholder="이메일 입력..."/>
	<input type="text" name="phone" placeholder="전화번호 입력..."/>
	<button type="submit">전송</button>
</form>
<script src="${pageContext.request.contextPath}/js/jquery-3.5.1.js"></script>
<script>
	$("#myForm").on("submit", function(){
		
		/*
			.attr()은 요소(element)의 속성(attribute)의 값을 가져오거나 추가한다.
			
			action 속성의 value(= insert.jsp)
			method 속성의 value(= post)
		*/
		var action=$(this).attr("action");
		var method=$(this).attr("method");
		
		/*
			.serialize()은 폼에 입력한 값을 query string으로 읽어온다.
			email=xxx&phone=xxx 형식으로 문자열이 읽어와진다.
		*/
		var query=$(this).serialize();
		console.log(query);
		
		//ajax요청을 통해서 폼에 입력한 내용을 전송한다.
		$.ajax({
			method:method, //post
			url:action, //insert.jsp
			data:query,
			success:function(data){
				console.log(data);
			}
		});
		//폼 전송을 강제로 막는다.
		return false;
	});
</script>
</body>
</html>