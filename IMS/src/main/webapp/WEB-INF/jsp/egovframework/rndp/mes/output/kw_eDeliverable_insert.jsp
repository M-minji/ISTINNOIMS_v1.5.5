<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://egovframework.gov/ctl/ui" prefix="ui" %>

<!-- 그리드 S -->
<script type="text/javascript" src="/js/cdnjs_cloudflare_com_ajax_libs_jqueryui_1.12.1/jquery.min.js"></script>
<script type="text/javascript" src="/js/cdnjs_cloudflare_com_ajax_libs_jqueryui_1.12.1/gridjs.production.min.js"></script>
<script type="text/javascript" src="/js/cdnjs_cloudflare_com_ajax_libs_jqueryui_1.12.1/jquery-ui.min.js"></script>
<link href="/css/mes/mermaid.min.css" rel="stylesheet"	type="text/css" />
<link href="/css/mes/jquery-ui.min.css" rel="stylesheet"	type="text/css" />
<link href="/css/mes/mermaid2.min.css" rel="stylesheet"	/>
<script src="/js/jquery.table2excel.js"></script>
<link href="/js/jBox/jBox.all.min.css" rel="stylesheet">
<script src="/js/jBox/jBox.all.min.js"></script>
<script type="text/javascript">
function modal1(message, focusSelector) {
	lastScrollY = window.scrollY;
	new jBox('Modal', {
	    height: 200,
	    title: message,
	    blockScrollAdjust: ['header'],
	    content:'',
	    overlay: false,   
	    addClass: 'no-content-modal',
	    position: {
	        x: 'center',
	        y: 'top'
	      },
	      offset: {
	        y: 65
	      },
	        onCloseComplete: function () {
	        	if (focusSelector) {
	            	window.scrollTo(0, 0);
	                setTimeout(() => {
	                    document.querySelector(focusSelector)?.focus();
	                }, 10);
	            } else{
	            	window.scrollTo(0, lastScrollY);
	            }
	        }
	  }).open();
  }
function modal3(message, onConfirm, onCancel) {
		new jBox('Confirm', {
			content: message,
		    cancelButton: '아니요',
		    confirmButton: '네',
		    blockScrollAdjust: ['header'],
		    confirm: onConfirm,
		    cancel: onCancel
		  }).open();
  }
$(document).ready(function(){	
	datepickerNameSet("eItemDate");     
	
	$('.tabs').each(function () {
		const $tabsContainer = $(this);
		const $inputs = $tabsContainer.find('.tab input[type="radio"]');
		const $contents = $tabsContainer.find('.tab_content');

		$inputs.on('change', function () {
			const targetId = '#' + $(this).attr('id') + '_content';
			$contents.hide();
			$tabsContainer.find(targetId).show();
		});

	  $inputs.first().prop('checked', true).trigger('change');
	});
}); 	

// 현재날짜
function nowDate(){
    var date = new Date();
    var year = date.getFullYear();
    var month = date.getMonth() + 1 < 10 ? "0" + (date.getMonth() + 1) : date.getMonth() + 1;
    var day = date.getDate() < 10 ? "0" + date.getDate() : date.getDate();
    var nowDate = year + "-" + month + "-" + day;
	
    return nowDate;
}
 


function setStartDate(d) {
    var settingDate = new Date();
    if(d == '7'){
        settingDate.setDate(settingDate.getDate()-7);
    	$('#topStartDate').val(settingDate.format("yyyy-MM-dd"));
    }else if(d == '1'){
        settingDate.setMonth(settingDate.getMonth()-1);
    	$('#topStartDate').val(settingDate.format("yyyy-MM-dd"));
    }else{
        settingDate.setMonth(settingDate.getMonth()-3);
    	$('#topStartDate').val(settingDate.format("yyyy-MM-dd"));
    }
    fn_guestList(1);
}

function cancel(){
	/* $("#mloader").show(); */
	document.frm.action = "/mes/output/kw_output_lf.do";
	document.frm.submit(); 
}
 
 
 
var row_Index = 0;
function addRow(gubun){
	var rowGubunCheck = "#lineRow"+gubun;
	  var eItemGubunArr = document.getElementsByName("eItemGubun").length;
	    var count = 1;
	    if(eItemGubunArr > 0){
		    // eAssetKey의 개수가 0이면 메시지를 추가
		    for (var i = 0; i < eItemGubunArr; i++) {
		    // gubun 변수와 eItemGubun의 값이 동일한지 비교합니다
			    if (document.getElementsByName("eItemGubun")[i].value === gubun) {
			        // 동일할 경우 count를 1 증가시킵니다
			        count++;
			    }
			}
		    if(row_Index == 0){
		    	row_Index =(eItemGubunArr+1);
		    }
	    }
		if(count == 1){
			var tbody = document.getElementById("lineRow"+gubun);
		    tbody.innerHTML = "";  
		}
		
		var innerStr = "";
		// 행삭제
		innerStr += "	<tr>";
		innerStr += "		<td>";
		innerStr += "			<a class='del' onclick=\"delRow(this,'"+gubun+"');\">X</a>";
		innerStr += "		</td>";
		// 산출물명
		innerStr += "		<td>" ;
		innerStr += "			<input type='text' id='eItemName_"+row_Index+"' name='eItemName' value='' style='width:98%;'  maxLength='30' />";
		innerStr += "			<input type='hidden' id='eItemIndex_"+row_Index+"' name='eItemIndex' value='"+row_Index+"'/>";
		innerStr += "			<input type='hidden' id='eItemGubun_"+row_Index+"' name='eItemGubun' value='"+gubun+"'/>";
		innerStr += "		</td>";
		// 작성일자
		innerStr += "		<td>";
		innerStr += "			<input type='text' id='eItemDate_"+row_Index+"' name='eItemDate' value='' class='inp_color' style='width:98%; text-align:center;'  readonly  />";
		innerStr += "		</td>";		
		// 소속
		innerStr += "		<td>";
		innerStr += "			<input type='text' id='eItemAffiliation_"+row_Index+"' name='eItemAffiliation' value='' style='width:98%;'  maxLength='30' />";
		innerStr += "		</td>";
		// 작성자
		innerStr += "		<td>";
		innerStr += "			<input type='text' id='eItemAuthor_"+row_Index+"' name='eItemAuthor' value='' style='width:98%;'  maxLength='30' />";
		innerStr += "		</td>";
		// 첨부파일
		innerStr += "		<td><a class='form_btn md' onclick=\"addFile('"+row_Index+"','"+gubun+"');\">파일추가</a>"; 
		innerStr += "		<div id='fileList"+row_Index+"'></div>";	
		innerStr += "		</td>";	
		// 비고
		innerStr += "		<td>";
		innerStr += "			<input type='text' id='eItemRemarks_"+row_Index+"' name='eItemRemarks' value=''  style='width:98%;'  maxLength='30' />";
		innerStr += "		</td>";	
		 
		innerStr += "	</tr>";
		$(innerStr).appendTo(rowGubunCheck);	
		datepickerIdSet("eItemDate_"+row_Index);
		row_Index++;
		
}
//행 삭제
function delRow(obj, gubun){ 
	var tr = $(obj).parent().parent();
	tr.remove();
	var rowGubunCheck = "lineRow"+gubun;
	  // eAssetKey의 개수를 다시 계산
    var eItemGubunArr = document.getElementsByName("eItemGubun").length;
    var count = 0;
    // eAssetKey의 개수가 0이면 메시지를 추가
    for (var i = 0; i < eItemGubunArr; i++) {
    // gubun 변수와 eItemGubun의 값이 동일한지 비교합니다
	    if (document.getElementsByName("eItemGubun")[i].value === gubun) {
	        // 동일할 경우 count를 1 증가시킵니다
	        count++;
	    }
	}
    if (count == 0) {
        var tbody = document.getElementById(rowGubunCheck);
        var messageRow = document.createElement('tr');
        var messageCell = document.createElement('td');
        
        messageCell.colSpan = 7;
        messageCell.textContent = "등록 정보가 없습니다.";
        
        messageRow.appendChild(messageCell);
        tbody.appendChild(messageRow);
    }
}

var fileRowIndex = "";
var fileRowGubun = "";
function addFile(rowIndex, rowGubun) {
    const url = "/mes/asset/popup/mesPDFAdd.do"; // 팝업 창 URL

    // 동적으로 form 생성
    const form = document.createElement("form");
    form.method = "POST";
    form.action = url;
    form.target = "ePDFAdd"; // 팝업 창 이름

    fileRowIndex = rowIndex;
    fileRowGubun = rowGubun;
    
    const csrfTokenGubun = document.createElement("input");
    csrfTokenGubun.type = "hidden";
    csrfTokenGubun.name = "csrfToken";
    csrfTokenGubun.value = $("input[name=csrfToken]").val();
    form.appendChild(csrfTokenGubun);

    const ePageGubun = document.createElement("input");
    ePageGubun.type = "hidden";
    ePageGubun.name = "ePageGubun";
    ePageGubun.value = "Y";
    form.appendChild(ePageGubun);
    
    // 팝업 창 열기
    window.open("", "ePDFAdd", "width=600,height=550,menubar=no,status=no,scrollbars=yes,location=no,resizable=yes");

    // 폼 제출
    document.body.appendChild(form);
    form.submit();

    // 폼 삭제 (클린업)
    document.body.removeChild(form);
}
var fileIndex = 0;
function addFileInfoRow(eIMGregId,eIMGregName,eIMGregExtension){  
	 var eFileRowIdArr = document.getElementsByName("eFileRowId").length;
		 if(eFileRowIdArr > 0 && fileIndex == 0){
			fileIndex =(eFileRowIdArr);  
		 }
		 fileIndex++;
	 
	
	  var rowGubunCheck = "#fileList"+fileRowIndex;
	  // 파일을 감싸는 div 요소 생성
	  var fileItemDiv_ID = "fileItem_"+fileIndex
       var fileDiv = $('<div class="fileItem" id="' + fileItemDiv_ID + '"></div>');
	  $(rowGubunCheck).append(fileDiv);
	  
	  var deleteLink = $('<a class="del" onclick="delFileRow(this, \'' + fileIndex + '\');">X</a>');
	  var spanElement = $('<span>' + eIMGregName + '</span>').attr('onclick', 'eDownload("' + eIMGregId + '")');
	  var fileIdInput = $('<input type="hidden" name="eFileRowId" id="eFileRowId_' + fileIndex + '">').val(eIMGregId);
	  var fileNameInput = $('<input type="hidden" name="eFileRowName" id="eFileRowName_' + fileIndex + '">').val(eIMGregName);
	  var fileGubunInput = $('<input type="hidden" name="eFileRowGubun" id="eFileRowGubun_' + fileIndex + '">').val(fileRowGubun); //탭분류 구분자
	  var fileIndexInput = $('<input type="hidden" name="eFileRowIndex" id="eFileRowIndex_' + fileIndex + '">').val(fileRowIndex); //하위테이블 구분자ㅑㅐ
	  
	  $("#"+fileItemDiv_ID).append(deleteLink);
	  $("#"+fileItemDiv_ID).append(spanElement);
	  $("#"+fileItemDiv_ID).append(fileIdInput);
	  $("#"+fileItemDiv_ID).append(fileNameInput);
	  $("#"+fileItemDiv_ID).append(fileGubunInput);
	  $("#"+fileItemDiv_ID).append(fileIndexInput);
	  
}

//파일 삭제 함수
function delFileRow(link, fileId) {
    $('#fileItem_' + fileId).remove(); // 해당 파일 항목의 div 요소를 삭제함
}

function insert_go(){
	if(chkIns()){  
		modal3("저장하시겠습니까?", function() {
			processSpecialCharacters();
			$("#mloader").show(); 
			document.frm.action = "/mes/output/kw_eDeliverable_i.do";
	 		document.frm.submit();
		});
	}
}
function delete_go(){
	if(confirm("산출물 정보를 초기화하시겠습니까?")){
		$("#mloader").show(); 
		document.frm.action = "/mes/output/kw_eDeliverable_d.do";
 		document.frm.submit();
	}
}
function chkIns(){
	if($("#eProjectStatus").val() == ""){
		modal1("진행상태를 입력하세요.", "#eProjectStatus");
		return false;
	}

	var eItemNameArr = document.getElementsByName("eItemName");
    var eItemGubunArr = document.getElementsByName("eItemGubun");
//     if (eItemNameArr.length === 0) {
//         alert("추가된 정보가 없습니다.");
//         return;
//     }
	for(var i = 0; i < eItemNameArr.length; i++){
		 var eItemGubunValue = eItemGubunArr[i].value;
         var prefix = "";
         if (eItemGubunValue === "A") {
             prefix = "착수 산출물의 ";
         } else if (eItemGubunValue === "B") {
             prefix = "수행 산출물의 ";
         } else if (eItemGubunValue === "C") {
             prefix = "완료 산출물의 ";
         }
         
		if(!eItemNameArr[i].value.trim()) {  // 빈 값 또는 공백만 있는 경우 체크
			modal1(prefix +"산출물명을 입력하세요.", "#eItemName_"+i);
          //  eItemNameArr[i].focus();
            return;  // 함수를 종료하여 이후 코드 실행을 막습니다.
        }
	}
	
	//검증완료후 콤마 처리
	
	return true;
}

function processSpecialCharacters() {
    var eItemNameArr = document.getElementsByName("eItemName");
    var eItemDateArr = document.getElementsByName("eItemDate");
    var eItemAffiliationArr = document.getElementsByName("eItemAffiliation");
    var eItemAuthorArr = document.getElementsByName("eItemAuthor");
    var eItemRemarksArr = document.getElementsByName("eItemRemarks");

    for (var i = 0; i < eItemNameArr.length; i++) {
        eItemNameArr[i].value = ConverttoHtml(eItemNameArr[i].value);
        eItemDateArr[i].value = ConverttoHtml(eItemDateArr[i].value);
        eItemAffiliationArr[i].value = ConverttoHtml(eItemAffiliationArr[i].value);
        eItemAuthorArr[i].value = ConverttoHtml(eItemAuthorArr[i].value);
        eItemRemarksArr[i].value = ConverttoHtml(eItemRemarksArr[i].value);
    }
}

function eDownload(eFileId){
	 
			window.open("<c:url value='/cmm/fms/FileDown.do?atchFileId="+eFileId+"&fileSn=0'/>");
		
}

function eDownloadAll(fileGubun){
	 var fileInputs = document.getElementsByName("eFileRowId");
	   var fileGubuns = document.getElementsByName("eFileRowGubun");
	    for (var i = 0; i < fileInputs.length; i++) {
	        var fileId = fileInputs[i].value;
	        var currentFileGubun = fileGubuns[i].value;
	        if (fileId !== null && fileId !== "" && currentFileGubun === fileGubun) {
	            window.open("/cmm/fms/FileDown.do?atchFileId=" + fileId + "&fileSn=0");
	        }
	    }
}
</script>
<style>
	.no-content-modal .jBox-content {
  		display: none; 
	}

	.no-content-modal .jBox-title {
		padding-bottom: 10px;
	}
	
	.no-content-modal .jBox-title {
	  	color: white;
	 	font-weight: 400;  
	    font-family: 'Pretendard GOV', sans-serif;
	}
	
	.jBox-Modal {
	  background: #4869fb !important;
	  border-radius: 8px !important;
   	  overflow: hidden !important;
   	  
}    
</style>
<form id="frm" name="frm" method="post" action="/mes/output/kw_output_lf.do">
	<input type="hidden" id="pageIndex" name="pageIndex" value="${mesOutputVO.pageIndex}">
	 
	<input type="hidden" id="outputKey" name="outputKey" value="" />
	<input type="hidden" id="sSignKey" name="sSignKey" value="" />
  	<input type="hidden" id="gubun" name="gubun" value="" />
  	<input type="hidden" id="eProjectNum" name="eProjectNum" value="${mesOutputVO.eProjectNum}" />
	 <div class="content_top">	
		<div class="content_tit">
			<h2>산출물 등록/수정</h2>
		</div>
	</div>
	
	<div class="normal_table row">
			<table>
				<tbody>
  				<tr>
	  				<th>사업명</th>
					<td>${projectInfo.eProjectName}
						<input type="hidden" id="eProjectName" name="eProjectName" style="width:90%; text-align: left;padding-left: 5px;"  value="" maxlength="30"/>
					</td>
					<th>사업기간</th>
					<td>${projectInfo.eStartDate} - ${projectInfo.eEndDate}
						<input type="hidden" class="inp_color" id="eStartDate" name="eStartDate" style="width:100px;text-align: center;" value="" readonly /> 
						<input type="hidden" class="inp_color" id="eEndDate" name="eEndDate" style="width:100px;text-align: center;" value="" readonly />
					</td>
					<th>주사업자</th>
					<td>${projectInfo.eMainContractor}
						<input type="hidden" id="eMainContractor" name="eMainContractor" style="width:90%; text-align: left;padding-left: 5px;"  maxlength="30"  value=""  />
					</td>
				</tr>
				<tr>
					<th>담당자</th>
					<td>${projectInfo.eManager}
						<input type="hidden" id="eManager" name="eManager" style="width:90%; text-align: left;padding-left: 5px;"  maxlength="30"  value=""  />
					</td>
					<th>담당자 연락처</th>
					<td>${projectInfo.eManagerContact}
						<input type="hidden" id="eManagerContact" name="eManagerContact" style="width:90%; text-align: left;padding-left: 5px;"  maxlength="30"  value=""  />
					</td>
					<th>담당자 이메일</th>
					<td>${projectInfo.eManagerEmail}
						<input type="hidden" id="eManagerEmail" name="eManagerEmail" style="width:90%; text-align: left;padding-left: 5px;"  maxlength="30"  value=""  />
					</td>
				</tr>
				<tr>
					<th>사업 PM</th>
					<td>${projectInfo.eProjectPM}
	 					<input type="hidden" id="eProjectPM" name="eProjectPM" style="width:90%; text-align: left;padding-left: 5px;"  maxlength="30"  value=""  />
					</td>
					<th>PM 연락처</th>
					<td>${projectInfo.ePMContact}
						<input type="hidden" id="ePMContact" name="ePMContact" style="width:90%; text-align: left;padding-left: 5px;"  maxlength="30"  value=""  />
					</td>
					<th>PM 이메일</th>
					<td>${projectInfo.ePMEmail}
						<input type="hidden" id="ePMEmail" name="ePMEmail" style="width:90%; text-align: left;padding-left: 5px;"  maxlength="30"  value=""  />
					</td>
				</tr>
				<tr>
					<th>비고</th>
					<td id="td_editor" colspan="3" align="center" scope="row">${projectInfo.eRemarks}</td>
					<th><span style="color: red">* </span>진행상태</th>
					<td> 
						<input type="text" id="eProjectStatus" name="eProjectStatus" style="width:90%; text-align: left;padding-left: 5px;"  maxlength="30"  value="${projectInfo.eProjectStatus eq '등록' ? '' : projectInfo.eProjectStatus}"  />
					</td>
				</tr>
			</tbody>
		</table>
	</div>
			
			<div class="tabs new_tabs">
				<div class="tab">
				    <label>
				    	<input id="all" type="radio" name="tab_item" checked>
				    	<span>착수 산출물</span>
				    </label>
				    <label>
				    	<input id="programming" type="radio" name="tab_item">
				    	<span>수행 산출물</span>
				    </label>
				    <label>
				    	<input id="design" type="radio" name="tab_item">
				    	<span>완료 산출물</span>
				    </label>
				</div>
			    
			    <div class="tab_content" id="all_content">
			        <div class="content_top innertab with_btn">
						<div class="content_tit">
							<h2>착수 산출물 </h2>
						</div>
						<div class="btns">
							 <button type="button" class="form_btn md" onclick="addRow('A');">산출물 추가</button>
						</div>
					</div>
					<div class="normal_table">
						<table>
							<thead>
								<tr>
									<th style="width: 8%;">구분</th>
									<th style="width: 10%;"><span style="color: red">* </span>산출물명</th>
									<th style="width: 10%;">작성일자</th>
									<th style="width: 12%;">소속</th> 
									<th style="width: 12%;">작성자</th> 
									<th style="width: 18%;">첨부파일
										<c:if test="${not empty  infoAList}">
											<span class="form_btn md" onclick="eDownloadAll('A');">모두 받기</span>
										</c:if>
									</th> 
									<th style="width: 18%;">비고</th> 
								</tr>
							</thead>
							<tbody id="lineRowA">
									 <c:forEach var="listA" items="${infoAList}" varStatus="i">
										<tr>
											<td>
												<a class='del' onclick="delRow(this,'A');">X</a>
											</td>
										
											<td>
												<input type='text' id='eItemName_${listA.eItemIndex}' name='eItemName' value='${listA.eItemName}' style='width:98%;'  maxLength='30' />
												<input type='hidden' id='eItemIndex_${listA.eItemIndex}' name='eItemIndex' value='${listA.eItemIndex}'/>
												<input type='hidden' id='eItemGubun_${listA.eItemIndex}' name='eItemGubun' value='A'/>
											</td>
										
											<td>
												<input type='text' id='eItemDate_${listA.eItemIndex}' name='eItemDate' value='${listA.eItemDate}' class='inp_color' style='width:98%; text-align:center;'  readonly  />
											</td>		
										
											<td>
												<input type='text' id='eItemAffiliation_${listA.eItemIndex}' name='eItemAffiliation' value='${listA.eItemAffiliation}' style='width:98%;'  maxLength='30' />
											</td>
										
											<td>
												<input type='text' id='eItemAuthor_${listA.eItemIndex}' name='eItemAuthor' value='${listA.eItemAuthor}' style='width:98%;'  maxLength='30' />
											</td>
										
											<td><a class='form_btn md' onclick="addFile('${listA.eItemIndex}','A');">파일추가</a> 
												<div id='fileList${listA.eItemIndex}'>
												 <c:forEach var="fileA" items="${fileAList}" varStatus="j">
													 <c:if test="${listA.eItemIndex eq fileA.eFileRowIndex}">
													    <div class="fileItem" id="fileItem_${j.index}">
													    <a class="del" onclick="delFileRow(this, '${j.index}');">X</a>
													    <span onclick="eDownload('${fileA.eFileRowId}');">${fileA.eFileRowName}</span>
													    <input type="hidden" name="eFileRowId" id="eFileRowId_${fileA.eFileRowIndex}" value="${fileA.eFileRowId}">
													    <input type="hidden" name="eFileRowName" id="eFileRowName_${j.index}" value="${fileA.eFileRowName}">
													    <input type="hidden" name="eFileRowGubun" id="eFileRowGubun_${j.index}" value="A">
													    <input type="hidden" name="eFileRowIndex" id="eFileRowIndex_${j.index}" value="${fileA.eFileRowIndex}"></div>
													</c:if>
												</c:forEach>
												</div>	
											</td>	
										
											<td>
												<input type='text' id='eItemRemarks_${listA.eItemIndex}' name='eItemRemarks' value='${listA.eItemRemarks}'  style='width:98%;'  maxLength='30' />
											</td>	
										
										</tr>
							 </c:forEach>
								<c:if test="${empty infoAList}">
									<tr>
										<td colspan="7" style="text-align: center;">등록 정보가 없습니다.</td>
									</tr>
								</c:if>
							</tbody>
						</table>
					</div>
	    	</div>
		    <div class="tab_content" id="programming_content">
				<div class="content_top innertab with_btn">
					<div class="content_tit">
						<h2>수행 산출물 </h2>
					</div>
					<div class="btns">
						 <button type="button" class="form_btn md"onclick="addRow('B');">산출물 추가</button>
					</div>
				</div>
				<div class="normal_table">
					<table>
							<thead>
							<tr>
								<th style="width: 8%;">구분</th>
								<th style="width: 10%;"><span style="color: red">* </span>산출물명</th>
								<th style="width: 10%;">작성일자</th>
								<th style="width: 12%;">소속</th> 
								<th style="width: 12%;">작성자</th> 
								<th style="width: 18%;">첨부파일
								 <c:if test="${not empty  infoBList}">
								 	<span class="form_btn md"  onclick="eDownloadAll('B');">모두 받기</span>
								 	</c:if>
							 	</th> 
								<th style="width: 18%;">비고</th> 
							</tr>
						</thead>
						<tbody id="lineRowB">
							 <c:forEach var="listB" items="${infoBList}" varStatus="i">
								<tr>
									<td>
										<a class='del' onclick="delRow(this,'B');">X</a>
									</td>
								
									<td>
										<input type='text' id='eItemName_${listB.eItemIndex}' name='eItemName' value='${listB.eItemName}' style='width:98%;'  maxLength='30' />
										<input type='hidden' id='eItemIndex_${listB.eItemIndex}' name='eItemIndex' value='${listB.eItemIndex}'/>
										<input type='hidden' id='eItemGubun_${listB.eItemIndex}' name='eItemGubun' value='B'/>
									</td>
								
									<td>
										<input type='text' id='eItemDate_${listB.eItemIndex}' name='eItemDate' value='${listB.eItemDate}' class='inp_color' style='width:98%; text-align:center;'  readonly  />
									</td>		
								
									<td>
										<input type='text' id='eItemAffiliation_${listB.eItemIndex}' name='eItemAffiliation' value='${listB.eItemAffiliation}' style='width:98%;'  maxLength='30' />
									</td>
								
									<td>
										<input type='text' id='eItemAuthor_${listB.eItemIndex}' name='eItemAuthor' value='${listB.eItemAuthor}' style='width:98%;'  maxLength='30' />
									</td>
								
									<td><a class='form_btn md' onclick="addFile('${listB.eItemIndex}','B');">파일추가</a> 
										<div id='fileList${listB.eItemIndex}'>
										 <c:forEach var="fileB" items="${fileBList}" varStatus="j">
											 <c:if test="${listB.eItemIndex eq fileB.eFileRowIndex}">
											    <div class="fileItem" id="fileItem_${j.index}">
											    <a class="del" onclick="delFileRow(this, '${j.index}');">X</a>
											    <span onclick="eDownload('${fileB.eFileRowId}');">${fileB.eFileRowName}</span>
											    <input type="hidden" name="eFileRowId" id="eFileRowId_${fileB.eFileRowIndex}" value="${fileB.eFileRowId}">
											    <input type="hidden" name="eFileRowName" id="eFileRowName_${j.index}" value="${fileB.eFileRowName}">
											    <input type="hidden" name="eFileRowGubun" id="eFileRowGubun_${j.index}" value="B">
											    <input type="hidden" name="eFileRowIndex" id="eFileRowIndex_${j.index}" value="${fileB.eFileRowIndex}"></div>
											</c:if>
										</c:forEach>
										</div>	
									</td>	
								
									<td>
										<input type='text' id='eItemRemarks_${listB.eItemIndex}' name='eItemRemarks' value='${listB.eItemRemarks}'  style='width:98%;'  maxLength='30' />
									</td>	
								
								</tr>
						 	</c:forEach>
							<c:if test="${empty infoBList}">
								<tr>
									<td colspan="7" style="text-align: center;">등록 정보가 없습니다.</td>
								</tr>
							</c:if>
						</tbody>
					</table>
				</div>
			</div>
	   	 <div class="tab_content" id="design_content">
		       <div class="content_top innertab with_btn">
						<div class="content_tit">
							<h2>완료 산출물 </h2>
						</div>
						<div class="btns">
							 <button type="button" class="form_btn md" onclick="addRow('C');">산출물 추가</button>
						</div>
					</div>
					<div class="normal_table">
						<table>
								<thead>
								<tr>
									<th style="width: 8%;">구분</th>
									<th style="width: 10%;"><span style="color: red">* </span>산출물명</th>
									<th style="width: 10%;">작성일자</th>
									<th style="width: 12%;">소속</th> 
									<th style="width: 12%;">작성자</th> 
									<th style="width: 18%;">첨부파일
										<c:if test="${not empty  infoCList}">
											<span class="form_btn md"  onclick="eDownloadAll('C');">모두 받기</span>
										</c:if>
									</th> 
									<th style="width: 18%;">비고</th> 
								</tr>
							</thead>
							<tbody id="lineRowC">
									 <c:forEach var="listC" items="${infoCList}" varStatus="i">
										<tr>
											<td>
												<a class='del' onclick="delRow(this,'C');">X</a>
											</td>
										
											<td>
												<input type='text' id='eItemName_${listC.eItemIndex}' name='eItemName' value='${listC.eItemName}' style='width:98%;'  maxLength='30' />
												<input type='hidden' id='eItemIndex_${listC.eItemIndex}' name='eItemIndex' value='${listC.eItemIndex}'/>
												<input type='hidden' id='eItemGubun_${listC.eItemIndex}' name='eItemGubun' value='C'/>
											</td>
										
											<td>
												<input type='text' id='eItemDate_${listC.eItemIndex}' name='eItemDate' value='${listC.eItemDate}' class='inp_color' style='width:98%; text-align:center;'  readonly  />
											</td>		
										
											<td>
												<input type='text' id='eItemAffiliation_${listC.eItemIndex}' name='eItemAffiliation' value='${listC.eItemAffiliation}' style='width:98%;'  maxLength='30' />
											</td>
										
											<td>
												<input type='text' id='eItemAuthor_${listC.eItemIndex}' name='eItemAuthor' value='${listC.eItemAuthor}' style='width:98%;'  maxLength='30' />
											</td>
										
											<td><a class='form_btn md' onclick="addFile('${listC.eItemIndex}','C');">파일추가</a> 
												<div id='fileList${listC.eItemIndex}'>
												 <c:forEach var="fileC" items="${fileCList}" varStatus="j">
													 <c:if test="${listC.eItemIndex eq fileC.eFileRowIndex}">
													    <div class="fileItem" id="fileItem_${j.index}">
													    <a class="del" onclick="delFileRow(this, '${j.index}');">X</a>
													    <span onclick="eDownload('${fileC.eFileRowId}');">${fileC.eFileRowName}</span>
													    <input type="hidden" name="eFileRowId" id="eFileRowId_${fileC.eFileRowIndex}" value="${fileC.eFileRowId}">
													    <input type="hidden" name="eFileRowName" id="eFileRowName_${j.index}" value="${fileC.eFileRowName}">
													    <input type="hidden" name="eFileRowGubun" id="eFileRowGubun_${j.index}" value="C">
													    <input type="hidden" name="eFileRowIndex" id="eFileRowIndex_${j.index}" value="${fileC.eFileRowIndex}"></div>
													</c:if>
												</c:forEach>
												</div>	
											</td>	
										
											<td>
												<input type='text' id='eItemRemarks_${listC.eItemIndex}' name='eItemRemarks' value='${listC.eItemRemarks}'  style='width:98%;'  maxLength='30' />
											</td>	
										
										</tr>
							 </c:forEach>
								<c:if test="${empty infoBList}">
									<tr>
										<td colspan="7" style="text-align: center;">등록 정보가 없습니다.</td>
									</tr>
								</c:if>
							</tbody>
						</table>
					</div>
		</div>
	</div>	
	
	<div class="bottom_btn">
		<c:if test="${staffVO.kStaffAuthDelFlag eq 'T'}">
		<!--  <button type="button" class="form_btn ico_refresh" onclick="delete_go();">산출물 초기화</button> -->
		</c:if>
		<button type="button" class="form_btn active" onclick="insert_go();">저장</button>
		<button type="button" class="form_btn" onclick="cancel();">취소</button>
	</div>
	
</form>
