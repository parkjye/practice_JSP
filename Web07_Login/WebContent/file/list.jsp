<%@page import="java.net.URLEncoder"%>
<%@page import="java.util.List"%>
<%@page import="test.file.dao.FileDao"%>
<%@page import="test.file.dto.FileDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/file/list.jsp</title>
<style>
	/*.page-display {margin: 0 auto;}*/
	.page-display a {
		text-decoration: none;
		color: #000;
	}
	
	.page-display ul li {		
		flaot:left;
		list-styel-type:none;
		margin-right:10px;
	}
	
	.page-display ul li.active {
		text-decoration: underline;
		/*font-weight: bold;*/
	}
	
	.page-display ul li.active a {
		color:red;
	}
</style>
</head>
<body>
<%
	//로그인 된 아이디 읽어오기(로그인을 하지 않으면 null)
	String id = (String)session.getAttribute("id");
	
	
	//--------페이징 처리 코드--------
	
	//한 페이지에 나타낼 row 의 갯수
	final int PAGE_ROW_COUNT=10;
	//하단 디스플레이 페이지 갯수
	final int PAGE_DISPLAY_COUNT=5;
		
	//보여줄 페이지의 번호
	//넘어오는 pageNum가 없으면 1페이지 노출
	int pageNum=1;
	//보여줄 페이지의 번호가 파라미터로 전달되는지 읽어와 본다.	
	String strPageNum=request.getParameter("pageNum");
	if(strPageNum != null){//페이지 번호가 파라미터로 넘어온다면
		//페이지 번호를 설정한다.
		pageNum=Integer.parseInt(strPageNum);
	}
	//보여줄 페이지 데이터의 시작 ResultSet row 번호
	int startRowNum=1+(pageNum-1)*PAGE_ROW_COUNT;
	//보여줄 페이지 데이터의 끝 ResultSet row 번호
	int endRowNum=pageNum*PAGE_ROW_COUNT;
	
	/*
		검색 키워드에 관련된 처리
	*/
	String keyword = request.getParameter("keyword");
	
	//인코딩된 키워드를 미리 만들어 둔다.
	String encdingK = "";
	
	try {	
		//키워드가 null이면 Exception발생
		encdingK = URLEncoder.encode("keyword");
	}catch(Exception e){}
	
	String condition = request.getParameter("condition");
	
	//검색 키워드와 startRowNum, endRowNum을 담을 FileDto객체 생성
	FileDto dto = new FileDto();
	dto.setStartRowNum(startRowNum);
	dto.setEndRowNum(endRowNum);
	
	//select된 결과를 담을 list
	List<FileDto> list = null;
	
	//전체 row의 갯수를 담을 변수
	int totalRow = 0;
	
	if(keyword != null) { //만일 키워드가 넘어온다면
		if(condition.equals("title_filename")){
			//검색 키워드를 FileDto 객체의 필드에 담는다.
			dto.setTitle(keyword);
			dto.setOrgFileName(keyword);
			
			//검색 키워드에 맞는 파일 목록을 얻어온다.
			list=FileDao.getInstance().getListTitleFileName(dto);
			
			//검색 키워드에 맞는 파일 목록 중에서 pageNum에 해당하는 목록 얻어오기
			totalRow=FileDao.getInstance().getCountTitleFileName(dto);
			
		}else if(condition.equals("title")) {
			dto.setTitle(keyword);
			list=FileDao.getInstance().getListTitle(dto);
			totalRow=FileDao.getInstance().getCountTitle(dto);
			
		}else if(condition.equals("writer")) {
			dto.setTitle(keyword);
			list=FileDao.getInstance().getListWriter(dto);
			totalRow=FileDao.getInstance().getCountWriter(dto);
			
		}else { //검색 키워드가 없으면 전체 목록을 얻어온다.
			//검색키워드가 없으면 빈문자열
			condition ="";
			keyword="";
			
			list = FileDao.getInstance().getList(dto);
			totalRow = FileDao.getInstance().getCount();
		}
	}
	
	//전체 row 의 갯수를 읽어온다.
	//int totalRow=list.size();
	
	//전체 페이지의 갯수 구하기
	int totalPageCount=(int)Math.ceil(totalRow/(double)PAGE_ROW_COUNT);
	
	//시작 페이지 번호
	int startPageNum=1+((pageNum-1)/PAGE_DISPLAY_COUNT)*PAGE_DISPLAY_COUNT;
	
	//끝 페이지 번호
	int endPageNum=startPageNum+PAGE_DISPLAY_COUNT-1;
	
	//끝 페이지 번호가 잘못된 값이라면 
	if(totalPageCount < endPageNum){
		endPageNum=totalPageCount; //보정해준다. 
	}
	
	/*
		startRowNum과 endRowNumdmf FileDto객체에 담고
		FileDto dto = new FileDto();
		dto.setStartRowNum(startRowNum);
		dto.setEndRowNum(endRowNum);
		
		//FileDto 객체를 인자로 전달해서 파일 목록을 얻어온다.
		List<FileDto> list = FileDao.getInstance().getList(dto); 
	*/
	
%>
<div class="container">
	<h1>파일목록입니다.</h1>
	<a href="private/upload_form.jsp">파일 업로드</a>
	<table>
		<thead>
			<tr>
				<th>번호</th>
				<th>작성자</th>
				<th>제목</th>
				<th>파일명</th>
				<th>파일크기</th>
				<th>등록일</th>
			</tr>
		</thead>
		<tbody>
			<%for(FileDto tmp:list) {%>
				<tr>
					<td><%=tmp.getNum() %></td>
					<td><%=tmp.getWriter() %></td>
					<td><%=tmp.getTitle() %></td>
					<td><a href="download.jsp"><%=tmp.getOrgFileName() %></a></td>
					<td><%=tmp.getFileSize() %></td>
					<td><%=tmp.getRegdate() %></td>
					<td>
						<!-- tmp.getWriter()는 null일 가능성이 없으니까 
							작성자를 기준으로 비교해야한다.
							id를 기준으로 비교하면 NullPointException발생할 가능성이 높음
						 -->
						<%if(tmp.getWriter().equals(id)) {%>
							<a href="private/delete.jsp?num=<%=tmp.getNum() %>">삭제</a>
						<%} %>
						
					</td>
				</tr>
			<%} %>
		</tbody>
	</table>

	<div class="page-display">
		<ul>
		<% if(startPageNum!=1){%>
			<li><a href="list.jsp?pageNum=<%=startPageNum-1 %>&condition=<%=condition %>&keyword=<%=encdingK %>">이전</a></li>
		<%} %>
		<%for(int i=startPageNum; i<=endPageNum; i++){ %>
			<% if(i==pageNum) {%>
				<li class="active"><a href="list.jsp?pageNum=<%=i %>&condition=<%=condition %>&keyword=<%=encdingK %>"><%=i %></a></li>
			<%} else{%>
				<li><a href="list.jsp?pageNum=<%=i %>&condition=<%=condition %>&keyword=<%=encdingK %>"><%=i %></a></li>
			<%} %>
		<%} %>
		<% if(endPageNum < totalPageCount){%>
			<li><a href="list.jsp?pageNum=<%=endPageNum+1 %>&condition=<%=condition %>&keyword=<%=encdingK %>">다음</a></li>
		<%} %>
		</ul>
	</div>
	<hr style="clear:left;"/>
	<!-- 데이터를 가져오기 위한 form이기 때문에 get방식 사용 -->
	<form action="list.jsp" method="get">
		<label for="condition">검색조건</label>
		<select name="condition" id="condition">
			<option value="title_filename">제목+파일명</option>
			<option value="title">제목</option>
			<option value="writer">작성자</option>
		</select>
		<input type="text" name="keyword" placeholder="검색어 입력"/>
		<button type="submit">검색</button>
	</form>
</div>
</body>
</html>