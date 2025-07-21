<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<title>선택하기</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link type="text/css" rel="stylesheet" href="/css/intra/popup.css"/>

<script type="text/javascript">
$(document).ready(function(){
	fn_position('0');
	var objkey = "${mesSignVO.kStaffKey1}".split(",");
	for(var k = 0; k < objkey.length; k++){
		for(var i = 0; i < document.getElementsByName("kStaffKey").length; i++){
			if(document.getElementsByName("kStaffKey")[i].value == objkey[k]){
				var num = $('input[name="kStaffKey"]')[i].id.split('_', 2)[1];
				fn_choice(num);
			}
		}
	}
	var pos = $("#kPos").val();
	$("#pos_"+pos).css("color", "blue");
	var obj = "${mesSignVO.gubun1}".split(",");
	console.log(obj)
	var preKStaffKey = "${mesSignVO.preKStaffKey}".split(",");
	var num = 0;
	if(obj != ''){
		for(var i = 0; i < obj.length; i++){
			if(obj[i] == '검토'){
				obj[i] = 'R'
			}else{
				obj[i] = 'A'
			}
			document.getElementsByName("gubun")[i].value = obj[i];
			num++;
		}
	}
});
// 선택
function fn_return(){
	if(incheck()){
		$("#referUL",opener.document).empty();//sign
		$("#paymentUL",opener.document).empty();//sign
		
		var gubun = $("input:checkbox[name='kSignViewGubun']:checked").val();
		var ln = document.getElementsByName("kStaffKey1").length;
		var arrKey = new Array();
		var arrGubun = new Array();
		if(ln > 0){
			if(gubun == 'Y'){
				for(var k=0; k<ln; k++){
					arrKey[k] 	= document.getElementsByName("kStaffKey1")[k].value;
					arrGubun[k]	= $("select[name=gubun]")[k].value
				}
				var params = "&sSingPathKey="+arrKey+"&sSingPathGubun="+arrGubun+"&sSingPathSubject="+$("#kSignSubName").val();
				$.ajax({
					type		: "post"
					, url		: "/mes/sign/kw_reCir_add.do"
					, data		: params
					, dataType	: "json"
					, cache		: false
					, async		: false
				});
			}
			var arr = new Array(); 
			var arr2 = new Array(); 
			for(var k=0; k<$('input[name="kStaffKey2"]:checked').length; k++){
				arr[k] = $('input[name="kStaffKey2"]:checked')[k].value
			}
			/* for(var i = 0; i < document.getElementsByName("kStaffKey").length; i++){
				for(var k=0; k<arr.length; k++){
					if(typeof document.getElementsByName("kStaffKey1")[i] != "undefined"){
						if(document.getElementsByName("kStaffKey1")[i].value == arr[k]){
							arr2[i] = document.getElementsByName("kStaffKey1")[i].value;
							break;
						}else{
							arr2[i] = '0';
						}
					}
				}
			} */
			

			if(typeof(opener.deleteGyeoljaeList) != "undefined"){
				window.opener.deleteGyeoljaeList();
			}
			for(var i=0; i<ln; i++){
				var obj = {
					kStaffKey			: document.getElementsByName("kStaffKey1")[i].value
					, kClassName		: document.getElementsByName("kClassName1")[i].value
					, kStaffName		: document.getElementsByName("kStaffName1")[i].value
					, kPositionName		: document.getElementsByName("kPositionName1")[i].value
					, gubun				: $("select[name=gubun]")[i].value
					, preKStaffKey		: arr2[i]
					, kSignViewGubun	: $("input:checkbox[name='kSignViewGubun']:checked").val()
				};
				if(typeof(opener.reCirSet) != "undefined"){
					window.opener.reCirSet(obj);
				}
			}
		}
		window.close();
	}
}

//검토자 및 결재자 유효성검사
function incheck(){
	var ln = document.getElementsByName("kStaffKey1").length;
	var gubunNum = 0;
	var num = 0;
	for(var i=0; i<ln; i++){
		 if($("select[name=gubun]")[i].value == '결재' || $("select[name=gubun]")[i].value == 'A'){
			gubunNum++;	
		}
		if($("select[name=gubun]")[i].value == '검토' || $("select[name=gubun]")[i].value == 'R'){
			num++;
		} 
	}
	if($("#kSignViewGubun").val() == 'Y'){
		if($("#kSignSubName").val() == ''){
			alert("결재선 저장시 제목입력을 해야됩니다.");
			return false;
		}
	}
	if(document.getElementsByName("kStaffKey1").length == ''){
		alert("결재자를 선택해야됩니다.");
		return false;
	} 
	if(gubunNum > 1){
		alert("결재자는 한명만 선택할 수 있습니다.");
		return false;
	}
	if(gubunNum == 0){
		alert("결재자 한명은 필수입니다.");
		return false;
	}
	return true;
}

// +, - 버튼 클릭
function fn_pluMi(){
	if($("#visible").val() == "F"){
		$(".innerLi").remove();
		var innerStr = "";
		<c:forEach var="pos" items="${positionList}" varStatus="i">
			innerStr += "	<li class='innerLi'>";
			innerStr += "		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a id='pos_${pos.kPositionKey}' class='pos' onclick='fn_position(${pos.kPositionKey});' style='cursor:pointer'> > ${pos.kPositionName}</a>";
			innerStr += "	</li>";
		</c:forEach>
		$("#ulRow").append(innerStr);
		
		$("#imgPluMi").attr("src", "/images/images/2mlastnode.gif" );
		$("#visible").val("T");
	}else{
		$("#imgPluMi").attr("src", "/images/images/2plastnode.gif");
		$("#visible").val("F");
		
		$(".innerLi").remove();
	}
}
// 이름 검색
function fn_positionSub(){
	var kPositionKey = $("#kPos").val();
	fn_position(kPositionKey);
}
// 부서 선택
function fn_position(key){
	$(".pos").css("color", "");
	$("#pos_"+key).css("color", "blue");
	$("#kPos").val(key);
	var params = "kPositionKey="+key;
	params += "&searchWord="+$("#searchWord").val();
	
	var ln = document.getElementsByName("kStaffKey1").length;
	var kStaffKey = "";
	
	for(var i=0; i<ln; i++){
		var kStaffKey1 = document.getElementsByName("kStaffKey1")[i].value;
		if(kStaffKey == ""){
			kStaffKey = kStaffKey1;
		}else{
			kStaffKey = kStaffKey + ",";
			kStaffKey = kStaffKey + kStaffKey1;
		}
	}
	
	params += "&kStaffKey1="+kStaffKey+"&kMenuKey="+$("#kMenuKey").val();
	
	$(".innerTr").remove();
	trRowIndex = 0;
	
	$.ajax({
		type		: "post"
		, url		: "/mes/sign/kw_getPositoinAjax.do"
		, data		: params
		, dataType	: "json"
		, cache		: false
		, async		: false
		, success	: function(msg){
			var list = msg.haha.tt;
			setStaff(list);
		}
	});
}
// 직원 셋팅
var trRowIndex = parseInt("${fn:length(list)}");
function setStaff(list){
	for(var i=0; i<list.length; i++){
		var obj = list[i];
		
		var innerStr = "";
		innerStr += "<tr id='tr_"+(trRowIndex)+"' class='innerTr' onclick='fn_choice("+(trRowIndex)+")'>";
		innerStr += "	<td>" + (obj.kStaffName);
		innerStr += "		<input type='hidden' id='kStaffName_"+(trRowIndex)+"' name='kStaffName' value='"+(obj.kStaffName)+"'/>";
		innerStr += "		<input type='hidden' id='kStaffKey_"+(trRowIndex)+"' name='kStaffKey' value='"+(obj.kStaffKey)+"'/>";
		innerStr += "		<input type='hidden' id='kPositionKey_"+(trRowIndex)+"' name='kPositionKey' value='"+(obj.kPositionKey)+"'/>";
		innerStr += "		<input type='hidden' id='kPositionName_"+(trRowIndex)+"' name='kPositionName' value='"+(obj.kPositionName)+"'/>";
		innerStr += "		<input type='hidden' id='kStaffNum_"+(trRowIndex)+"' name='kStaffNum' value='"+(obj.kStaffNum)+"'/>";
		innerStr += "		<input type='hidden' id='kStaffId_"+(trRowIndex)+"' name='kStaffId' value='"+(obj.kStaffId)+"'/>";
		innerStr += "	</td>";
		innerStr += "	<td>" + (obj.kClassName);
		innerStr += "		<input type='hidden' id='kClassName_"+(trRowIndex)+"' name='kClassName' value='"+(obj.kClassName)+"'/>";
		innerStr += "	</td>";
		innerStr += "</tr>";
		
		$("#taRow").append(innerStr);
		trRowIndex++;
	}
}
// 직원 선택
var listRowIndex = parseInt("${fn:length(chList)}")+parseInt("${fn:length(list)}");
function fn_choice(idx){
	var kStaffName = $("#kStaffName_"+idx).val();
	var kStaffKey = $("#kStaffKey_"+idx).val();
	var kClassName = $("#kClassName_"+idx).val();
	var kStaffNum = $("#kStaffNum_"+idx).val();
	var kStaffId = $("#kStaffId_"+idx).val();
	var kPositionKey = $("#kPositionKey_"+idx).val();
	var kPositionName = $("#kPositionName_"+idx).val();
	var gubun = $("#gubun_"+idx).val();
	
	var innerStr = "";
	innerStr += "<tr id='list_"+(listRowIndex)+"' class='innerList'>";
	innerStr += "	<td>";
	innerStr += "		<span id='order_"+(listRowIndex)+"' class='order'></span>";
	innerStr += "		<input type='hidden' id='kStaffKey1_"+(listRowIndex)+"' name='kStaffKey1' value='"+(kStaffKey)+"'/>";
	innerStr += "		<input type='hidden' id='kPositionKey1_"+(listRowIndex)+"' name='kPositionKey1' value='"+(kPositionKey)+"'/>";
	innerStr += "		<input type='hidden' id='kPositionName1_"+(listRowIndex)+"' name='kPositionName1' value='"+(kPositionName)+"'/>";
	innerStr += "		<input type='hidden' id='kStaffNum1_"+(listRowIndex)+"' name='kStaffNum1' value='"+(kStaffNum)+"'/>";
	innerStr += "		<input type='hidden' id='kStaffId1_"+(listRowIndex)+"' name='kStaffId1' value='"+(kStaffId)+"'/>";
	innerStr += "	</td>";
	innerStr += "	<td>" + kStaffName;
	innerStr += "		<input type='hidden' id='kStaffName1_"+(listRowIndex)+"' name='kStaffName1' value='"+(kStaffName)+"'/>";
	innerStr += "	</td>";
	innerStr += "	<td>" + kClassName;
	innerStr += "		<input type='hidden' id='kClassName1_"+(listRowIndex)+"' name='kClassName1' value='"+(kClassName)+"'/>";
	innerStr += "	</td>";
	innerStr += "	<td>";
	innerStr += "		<select id='gubun_"+(listRowIndex)+"' name='gubun' onchange='PRcheck("+(listRowIndex)+");'>";
	innerStr += "			<option value='검토'>검토</option>";
	innerStr += "			<option value='결재'>결재</option>";
	innerStr += "		</select>";
	innerStr += "	</td>";
	innerStr += "	<td onclick='event.cancelBubble = true;'>";
	innerStr += "		<button type='button' onclick='moveUp(this)'><img src='/images_intra/btn/up.png' style='width:20px;'></button>";
	innerStr += "		<button type='button' onclick='moveDown(this)'><img src='/images_intra/btn/down.png' style='width:20px;'></button>";
	innerStr += "	</td>";
	innerStr += "	<td>";
	innerStr += "		<button type='button' onclick='fn_unChoice("+(listRowIndex)+")'><img src='/images_intra/btn/btn_del_s2.gif' style='width:20px;'></button>";
	innerStr += "	</td>";
	innerStr += "</tr>";
	
	$("#listRow").append(innerStr);
	listRowIndex++;
	
	setOrder();
	
	$("#tr_"+idx).remove();
}
function PRcheck(key){
	var gubun = document.getElementById("gubun_"+key+"").value;
	if(gubun == 'R'){
		$("#predecessor_"+key+"").show();
	}else{
		$("#predecessor_"+key+"").hide();
	}
}


// 순번 셋팅
function setOrder(){
	var ln = document.getElementsByName("kStaffKey1").length;
	for(var i=0; i<ln; i++){
		$(".order").eq(i).text(i+1);
	}
}
// 직원 선택 취소
function fn_unChoice(idx){
	var kStaffName1 = $("#kStaffName1_"+idx).val();
	var kStaffKey1 = $("#kStaffKey1_"+idx).val();
	var kClassName1 = $("#kClassName1_"+idx).val();
	var kStaffNum1 = $("#kStaffNum1_"+idx).val();
	var kStaffId1 = $("#kStaffId1_"+idx).val();
	var kPositionKey1 = $("#kPositionKey1_"+idx).val();
	var kPositionName1 = $("#kPositionName1_"+idx).val();
	
	if(($("#kPos").val() == kPositionKey1 || $("#kPos").val() == "0") && ($("#searchWord").val() == "" || kStaffName1.search($("#searchWord").val()) > -1)){
		var innerStr = "";
		innerStr += "<tr id='tr_"+(trRowIndex)+"' class='innerTr' onclick='fn_choice("+(trRowIndex)+")'>";
		innerStr += "	<td>" + kStaffName1;
		innerStr += "		<input type='hidden' id='kStaffName_"+(trRowIndex)+"' name='kStaffName' value='"+(kStaffName1)+"'/>";
		innerStr += "		<input type='hidden' id='kStaffKey_"+(trRowIndex)+"' name='kStaffKey' value='"+(kStaffKey1)+"'/>";
		innerStr += "		<input type='hidden' id='kPositionKey_"+(trRowIndex)+"' name='kPositionKey' value='"+(kPositionKey1)+"'/>";
		innerStr += "		<input type='hidden' id='kPositionName_"+(trRowIndex)+"' name='kPositionName' value='"+(kPositionName1)+"'/>";
		innerStr += "		<input type='hidden' id='kStaffNum_"+(trRowIndex)+"' name='kStaffNum' value='"+(kStaffNum1)+"'/>";
		innerStr += "		<input type='hidden' id='kStaffId_"+(trRowIndex)+"' name='kStaffId' value='"+(kStaffId1)+"'/>";
		innerStr += "	</td>";
		innerStr += "	<td>" + kClassName1;
		innerStr += "		<input type='hidden' id='kClassName_"+(trRowIndex)+"' name='kClassName' value='"+(kClassName1)+"'/>";
		innerStr += "	</td>";
		innerStr += "</tr>";
		
		$("#taRow").append(innerStr);
		trRowIndex++;
	}
	$("#list_"+idx).remove();
	setOrder();
}
// 올리기
function moveUp(el){
	var $tr = $(el).parent().parent();
	$tr.prev().before($tr);
	setOrder();
}
// 내리기
function moveDown(el){
	var $tr = $(el).parent().parent();
	$tr.next().after($tr);
	setOrder();
}
function oneCheckbox (a) {
    var obj = document.getElementsByName ("kStaffKey2");
    for (var i = 0; i <obj.length; i ++) {
        if (obj[i] != a) {
            obj[i].checked = false;
        }
    }
}
function fn_move(key){
	<c:forEach var="pos" items="${positionList}" varStatus="i">
		<c:if test="${i.first}">
			var pos = "${pos.kPositionKey}";
		</c:if>
	</c:forEach> 
	$.ajax({
		type			: "post"
		, url			: "/mes/sign/kw_sign_select_path.do"
		, dataType		: "json"
		, data			: {"sSingPathNum" : key, "kMenuKey" : $("#kMenuKey").val()}
		, success		: function(msg){
			var list = msg.haha.tt;
			$(".pos").css("color", "");
			$("#pos_"+pos).css("color", "blue");
 			$("#taRow").empty();
 			 if (!list || list.length === 0) {
 	            alert("해당 메뉴의 권한자가 없습니다");
 	           return;  // 함수 종료
 			 }
			var str = "";
			<c:forEach var="list" items="${list}" varStatus="i">
			str	+=	"<tr id='tr_${i.index}' class='innerTr' onclick='fn_choice(${i.index})'>"
			str	+=	"	<td>"
			str	+=	"		${list.kStaffName}"
			str	+=	"		<input type='hidden' id='kStaffName_${i.index}' name='kStaffName' value='${list.kStaffName}'/>"
			str	+=	"		<input type='hidden' id='kStaffKey_${i.index}' name='kStaffKey' class='ksKey' value='${list.kStaffKey}'/>"
			str	+=	"		<input type='hidden' id='kPositionKey_${i.index}' name='kPositionKey' value='${list.kPositionKey}'/>"
			str	+=	"		<input type='hidden' id='kPositionName_${i.index}' name='kPositionName' value='${list.kPositionName}'/>"
			str	+=	"	</td>"
			str	+=	"	<td>"
			str	+=	"		${list.kClassName}"
			str	+=	"		<input type='hidden' id='kClassName_${i.index}' name='kClassName' value='${list.kClassName}'/>"
			str	+=	"		<input type='hidden' id='kStaffId_${i.index}' name='kStaffId' value='${list.kStaffId}'/>"
			str	+=	"		<input type='hidden' id='kStaffNum_${i.index}' name='kStaffNum' value='${list.kStaffNum}'/>"
			str	+=	"	</td>"
			str	+=	"</tr>"
			</c:forEach>
			$("#taRow").append(str);
			
			var kn = $(".ksKey").length;
			var innerStr = "";
			$("#listRow").empty();
			for(var i=0; i<list.length; i++){
				$("#kSignSubName").val(list[0].kSignSubName);
				innerStr += "<tr id='list_"+(i)+"' class='innerList'>";
				innerStr += "	<td>";
				innerStr += "		<span id='order_"+(i)+"' class='order'>"+(i+1)+"</span>";
				innerStr += "		<input type='hidden' id='kStaffKey1_"+(i)+"' name='kStaffKey1' value='"+(list[i].kSignSubStaffKey)+"'/>";
				innerStr += "		<input type='hidden' id='kPositionKey1_"+(i)+"' name='kPositionKey1' value='"+(list[i].kPositionKey)+"'/>";
				innerStr += "		<input type='hidden' id='kPositionName1_"+(i)+"' name='kPositionName1' value='"+(list[i].kPositionName)+"'/>";
				innerStr += "		<input type='hidden' id='kStaffNum1_"+(i)+"' name='kStaffNum1' value='"+(list[i].kStaffNum)+"'/>";
				innerStr += "		<input type='hidden' id='kStaffId1_"+(i)+"' name='kStaffId1' value='"+(list[i].kStaffId)+"'/>";  
				innerStr += "	</td>";
				innerStr += "	<td>" + list[i].kStaffName+"_"+list[i].sSingPathGubun;
				innerStr += "		<input type='hidden' id='kStaffName1_"+(i)+"' name='kStaffName1' value='"+(list[i].kStaffName)+"'/>";
				innerStr += "	</td>";
				innerStr += "	<td>" + list[i].kClassName;
				innerStr += "		<input type='hidden' id='kClassName1_"+(i)+"' name='kClassName1' value='"+(list[i].kClassName)+"'/>";
				innerStr += "	</td>";
				innerStr += "	<td>";
				innerStr += "		 <select id='gubun_"+(i)+"' name='gubun' onchange='PRcheck("+(i)+");'>";
				innerStr += "			<option value='검토' >검토</option>";
				innerStr += "			<option value='결재' >결재</option>";
// 				innerStr += "		 	<option value='B'>협조</option>";
				innerStr += "		</select>";
// 				innerStr += "		<a id='predecessor_"+(i)+"'><input type='checkbox' id='predecessorCheck_"+(i)+"' name='kStaffKey2' value='"+(list[i].kSignSubStaffKey)+"'><label for='predecessorCheck_"+(i)+"'>전결자 선택</label></a>";
				innerStr += "	</td>";
				innerStr += "	<td onclick='event.cancelBubble = true;'>";
				innerStr += "		<button type='button' onclick='moveUp(this)'><img src='/images_intra/btn/up.png' style='width:20px;'></button>";
				innerStr += "		<button type='button' onclick='moveDown(this)'><img src='/images_intra/btn/down.png' style='width:20px;'></button>";
				innerStr += "	</td>";
				innerStr += "	<td>";
				innerStr += "		<button type='button' onclick='fn_unChoice("+(i)+")'><img src='/images_intra/btn/btn_del_s2.gif'></button>";
				innerStr += "	</td>";
				innerStr += "</tr>";
				for(var t=0; t<kn; t++){
					var key = $(".ksKey").eq(t).val();
					if(list[i].kSignSubStaffKey == key){
						ksText = $(".ksKey").eq(t).closest('tr').attr('id');
						$("#"+ksText+"").remove();
					}
				}
			}
			$("#listRow").append(innerStr);
			for(var k=0; k<list.length; k++){
				$("#gubun_"+(k)+"").val(list[k].sSingPathGubun).attr("selected", "selected");
				PRcheck(k);
			}
			fn_position('0');
		}
	});
}
function deletePath(key){
	$.ajax({
		type			: "post"
		, url			: "/mes/sign/kw_sign_delete_path.do"
		, dataType		: "json"
		, data			: {"sSingPathNum" : key}
		, success		: function(msg){
			window.location.reload();
		}
	});
}
function fn_checkChange(){
	if($("input:checkbox[name=kSignViewGubun]").is(":checked") == true) {
		  $("#kSignViewGubun").val("Y");
	}else{
		$("#kSignViewGubun").val("");
	}
}


</script>

<style>
#header {layout:header;}
tr:hover{ background:#f1f1f1;}
th{border:1px solid #d1d1d1; border-left:none; border-top:none;text-align:center; background:#3a719e;padding:0.4em 0;color:#fff; font-weight:400;position: sticky;}
td{border:1px solid #d1d1d1; text-align:center;padding:0.4em 0;}
.h2_name{font-size:14px; display: flex; }
.h2_name>a{padding:5px 0;}
.h2_name>a>img{margin-top:-3px;}
button{background-color: initial; border: 0;width: 29px;}
button:focus{border: none;outline:none;}
.comCss{
	padding: 10px;
    text-align: left;
    box-shadow: 1px 1px 3px 1px #dadce0;
}
nav {
  display: inline-block;
  vertical-align: middle;
  width: 100%;
}
.cusUl {
  list-style: none;
  margin: 0;
  padding: 0;
  display: flex;
  border: 1px solid #d1d1d1;
}
.button {
	color: rgba(30, 22, 54, 0.6);
	box-shadow: rgba(30, 22, 54, 0.4) 0 0px 0px 2px inset;
}

.button:hover {
	color: rgba(255, 255, 255, 0.85);
	box-shadow: rgba(30, 22, 54, 0.7) 0 0px 0px 40px inset;
}
.button {
	-webkit-transition: all 200ms cubic-bezier(0.390, 0.500, 0.150, 1.360);
	-moz-transition: all 200ms cubic-bezier(0.390, 0.500, 0.150, 1.360);
	-ms-transition: all 200ms cubic-bezier(0.390, 0.500, 0.150, 1.360);
	-o-transition: all 200ms cubic-bezier(0.390, 0.500, 0.150, 1.360);
	transition: all 200ms cubic-bezier(0.390, 0.500, 0.150, 1.360);
	display: block;
	margin: 10px 0 10px 10px;
	max-width: 180px;
	text-decoration: none;
	border-radius: 4px;
	padding: 10px 10px;
}
</style>
<form id="frm" name="frm" method="post" action="/intra/sign/popup/kw_reCir_pop.do" onsubmit="return false;">  
	<input type="hidden" id="kPos" name="kPos" value="${mesSignVO.kPos}"/>
	
	<input type="hidden" id="visible" name="visible" value="T"/>
	<input type="hidden" id="kMenuKey" name="kMenuKey" value="${mesSignVO.kMenuKey}"/>
	
	<div class="pop_head2">
		<div id="pop_head2">
			<div class="tit">
				<h3 style="cursor:default;">받는사람 선택 </h3>
			</div>
		</div>
		<div id="itemCateZone" class="tbl_top2">
			<ul class="tbl_top_right2">
				<li>
					<input type="checkbox"  id="kSignViewGubun" name="kSignViewGubun" value="" onchange="fn_checkChange();">결재선 저장
					<a style="cursor: pointer;" onclick="fn_return();">선택</a>
				</li>
			</ul>
		</div>
	</div>
	
	<div style="width:46%; float:left; margin-left:1%;">
		<h2 class="h2_name"><a style="cursor:default;"><img src="/images_intra/btn/mo.png">조직도</a><a style="font-size:10px;">( 부서를 선택하시면 소속된 직원이 리스트업됩니다.) </a></h2>
		<div style="border:1px solid #d1d1d1; height:200px; overflow-y:scroll;">
			<ul id="ulRow">
				<li>
					<a id="com" onclick="fn_pluMi();" style="cursor:pointer"><img id="imgPluMi" src="/images/images/2mlastnode.gif"/></a>	<!-- '+'버튼 이미지로 넣기('-'이거도 포함) -->
					이노솔루텍
				</li>
				<c:forEach var="pos" items="${positionList}" varStatus="i">
					<li class="innerLi">
						&nbsp;&nbsp;&nbsp;&nbsp;
						<a id="pos_${pos.kPositionKey}" class="pos" onclick="fn_position('${pos.kPositionKey}');" style="cursor:pointer"> > ${pos.kPositionName}</a>
					</li>
				</c:forEach>
			</ul>
		</div>
		<div class="tbl_btn_right2">
			<ul>
				<li>
					<input type="text" id="searchWord" name="searchWord" class="searchWord" value="${mesSignVO.searchWord}" onKeydown="if(event.keyCode == 13){fn_positionSub();}" style="cursor:text;"/>
				</li>
				<li>
					<a onclick="fn_positionSub();">이름 찾기</a>
				</li>
			</ul>
		</div>
		<div style="border:1px solid #d1d1d1; height:260px; overflow-y:scroll;">

			<table style="width:100%">
				<colgroup>
					<col width="50%;">
					<col width="50%;">
				</colgroup>
				<thead>
					<tr style="cursor:default;">
						<th>성명</th>
						<th>직급</th>
					</tr>
				</thead>
				<tbody id="taRow">
					<c:forEach var="list" items="${list}" varStatus="i">
						<tr id="tr_${i.index}" class="innerTr" onclick="fn_choice('${i.index}')">
							<td>
								${list.kStaffName}
								<input type="hidden" id="kStaffName_${i.index}" name="kStaffName" value="${list.kStaffName}"/>
								<input type="hidden" id="kStaffKey_${i.index}" name="kStaffKey" value="${list.kStaffKey}"/>
								<input type="hidden" id="kPositionKey_${i.index}" name="kPositionKey" value="${list.kPositionKey}"/>
								<input type="hidden" id="kPositionName_${i.index}" name="kPositionName" value="${list.kPositionName}"/>
							</td>
							<td>
								${list.kClassName}
								<input type="hidden" id="kClassName_${i.index}" name="kClassName" value="${list.kClassName}"/>
								<input type="hidden" id="kStaffId_${i.index}" name="kStaffId" value="${list.kStaffId}"/>
								<input type="hidden" id="kStaffNum_${i.index}" name="kStaffNum" value="${list.kStaffNum}"/>
							</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>

	</div>
	<div style="width:50%; float:left; margin-left:2%;">
		<h2 style="font-size: medium; margin-bottom: 9px;">*제목 설정</h2>
		<input type="text" id="kSignSubName" name="kSignSubName" style="width: 95%; text-align: left;">
		<h2 class="h2_name" style="cursor:default;"><a><img src="/images_intra/btn/mo.png">받는 사람선택</a></h2>
		<div style="height:452px; border:1px solid #d1d1d1; overflow-y:scroll;">
			<table style="width:100%;">
				<colgroup>
					<col width="10%;">
					<col width="15%;">
					<col width="15%;">
					<col width="35%;">
					<col width="*%;">
				</colgroup>
				<thead>
					<tr style="cursor:default;">
						<th>순번</th>
						<th>성명</th>
						<th>직급</th>
						<th>선택</th>
						<th>정렬</th>
						<th>취소</th>
					</tr>
				</thead>
				<tbody id="listRow">
					<c:forEach var="list" items="${chList}" varStatus="i">
						<tr id="list_${i.index}" class="innerList">
							<td>
								<span id="order_${i.index}" class="order">${i.index + 1}</span>
								<input type="hidden" id="kStaffKey1_${i.index}" name="kStaffKey1" value="${list.kStaffKey}"/>
								<input type="hidden" id="kPositionKey1_${i.index}" name="kPositionKey1" value="${list.kPositionKey}"/>
								<input type="hidden" id="kPositionName1_${i.index}" name="kPositionName1" value="${list.kPositionName}"/>
								<input type="hidden" id="kStaffNum1_${i.index}" name="kStaffNum1" value="${list.kStaffNum}"/>
								<input type="hidden" id="kStaffId1_${i.index}" name="kStaffId1" value="${list.kStaffId}"/>  
							</td>
							<td>
								${list.kStaffName}
								<input type="hidden" id="kStaffName1_${i.index}" name="kStaffName1" value="${list.kStaffName}"/>
							</td>
							<td>
								${list.kClassName}
								<input type="hidden" id="kClassName1_${i.index}" name="kClassName1" value="${list.kClassName}"/>
							</td>
							<td>
								<select id="gubun_${i.index}" name="gubun" onchange="PRcheck(${i.index});">
									<option value='R'>검토</option>
								 	<option value='A'>결재</option>
								</select>
							</td>
							<td onclick="event.cancelBubble = true;">
								<button type="button" onclick="moveUp(this)"><img src="/images_intra/btn/up.png" style="width:20px;"></button>   
								<button type="button" onclick="moveDown(this)"><img src="/images_intra/btn/down.png" style="width:20px;"></button>
							</td>
							<td>
								<button type='button' onclick='fn_unChoice("${i.index}")'><img src='/images_intra/btn/btn_del_s2.gif'></button>
							</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</div>
	
	<div class="comCss">
		<nav>
			<ul class="cusUl" style=" margin-top: 10px;">
				<h1 style="font-size: initial; margin-top: 20px;">저장된 결재선:</h1>
				<c:forEach var="item" items="${pathList}">
					<li onclick="fn_move('${item.sSingPathNum}');"  class="button" style="cursor: pointer;">
	       				<c:out value="${item.sSingPathSubject}"/>
	       			</li>
	       			<div style="cursor:pointer; padding-left: 5px;">
	       				<a style="font-size:initial;" onclick="deletePath(${item.sSingPathNum});">X</a>
	       			</div>
				</c:forEach>
			</ul>
		</nav>
   	</div>
</form>