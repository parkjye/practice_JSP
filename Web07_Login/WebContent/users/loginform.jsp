<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>users/loginform.jsp</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.css" />
</head>
<body>
<div class="container">
	<h1>로그인 폼</h1>
	<form action="login.jsp" method="post">
		<div class="form-group">
			<label for="id">아이디</label>
			<input type="text" name="id" id="id"/>
		</div>
		
		<div class="form-group">
			<label for="pwd">비밀번호</label>
			<input type="text" name="pwd" id="pwd"/>
		</div>
		
		<button type="submit">로그인</button>
		<a href="../index.jsp">홈으로 가기</a>			
	</form>
</div>
</body>
</html>