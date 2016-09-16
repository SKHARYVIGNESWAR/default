<%--$Id$ --%>
<%@page import="com.adventnet.iam.xss.IAMEncoder"%>
<%@page import="org.json.JSONObject"%>
<%@page import="com.adventnet.crm.tpi.ctiapi.util.CtiApiUtil"%>
<%@ page errorPage="/jsp/common/Failure.jsp" contentType="text/html;charset=UTF-8" language="java" %>

<%
	String sipUsername = "";
	String sipPassword = "";
	String sipDomain = "";
	String sipCallrate = "";
	String sampleSipTitle = "";
	String sampleSipResponse = "";
	Boolean enabelSip = Boolean.FALSE;
	
	String sipConfObjStr = request.getAttribute("sipConfObj")+"";
	JSONObject sipConfObj;
	
	if( CtiApiUtil.checkNotNull(sipConfObjStr))
	{
		sipConfObj = new JSONObject(sipConfObjStr);
		sipUsername = sipConfObj.has("sipusername") ? sipConfObj.get("sipusername")+"" : "";//No i18n
		sipPassword = sipConfObj.has("sippassword") ? sipConfObj.get("sippassword")+"" : "";//No i18n
		sipDomain = sipConfObj.has("sipdomain") ? sipConfObj.get("sipdomain")+"" : "";//No i18n
		sipCallrate = sipConfObj.has("sipcallrateprefix") ? sipConfObj.get("sipcallrateprefix")+"" : "";//No i18n
		enabelSip = sipConfObj.has("enablesip") ? Boolean.valueOf(sipConfObj.get("enablesip")+"") : Boolean.FALSE;//No i18n
		sampleSipTitle = "The following SIP tag formed insided Dial tag of TWIML when making click2call from CRM UI:";//No i18n
		sampleSipResponse = "<Sip username=\""+sipUsername+"\" password=\""+sipPassword+"\">sip:"+sipCallrate+"123456@"+sipDomain+"</Sip>";//No i18n
	}
%>
<style>
.sip_title{
	color:#333333;
	font-family: ProximaNovaRegular;
	font-size:20px;
}
.sip_label{
	font-size:14px;
	color:#868686;
	font-family:ProximaNovaRegular;
}
.sip_formcontainer{
	width:800px;
	margin:0 auto;
	padding:20px;
	background:#fff;
	height:500px;
}
.sip_text{
	width:188px;
	height:28px;
	border:1px solid #d3d3d3;
	border-radius:2px;
}
.sip_primarybtn{
	font-size:14px;
	color:#fff;
	background-color:#84b9e4;
	border-radius:3px;
	padding: 7px 20px;
	border:none;
}
.sip_secbtn{
	font-size:14px;
	color:#a09f9f;
	background-color:#eaeaea;
	border-radius:3px;
	padding: 7px 12px;
	border:none;
}
.sip_primarybtn:hover{
	background-color:#76bbf0;
}
.sip_secbtn:hover{
	background-color:#f3f3f3;
	color:#b0afb0;
}
</style>
<head>
</head>
<body>
<div class="sip_formcontainer">
<div class="sip_title aligncenter cB">Sip Outgoing Call Configuration</div><%-- No i18n --%>
<div class="sip_overallContainer p30">
	<div class="sip_enableradio fL cB mT30">
	<%
		if( enabelSip)
		{
	%>
		<input type="checkbox" name="sipEnable" id="sipEnable" class="fL mT2" checked>
	<%
		}
		else
		{
	%>
		<input type="checkbox" name="sipEnable" id="sipEnable" class="fL mT2">
	<%
		}
	%>
		<label for="sip_radio" class="sip_label mL5 fL">Enable SIP for outgoing Call</label><%-- No i18n --%>
	</div>
	<div class="sip_formdetais fL cB mT30">
		<div class="formelements cB fL">
			<div class="fL sip_label fL cB mT5">User Name</div><%-- No i18n --%>
			<div class="fL mL50">
				<input type="text" id="sipUsername" class="sip_text fL" value="<%=IAMEncoder.encodeHTMLAttribute(sipUsername) %>" >
			</div>
		</div>
		<div class="formelements cB fL mT20">
			<div class="fL sip_label fL cB mT5">Password</div><%-- No i18n --%>
			<div class="fL " style="margin-left:60px">
				<input type="password" id="sipPassword" class="sip_text fL" value="<%=IAMEncoder.encodeHTMLAttribute(sipPassword) %>" >
			</div>
		</div>
		<div class="formelements cB fL mT20">
			<div class="fL sip_label fL cB mT5">Domain</div><%-- No i18n --%>
			<div class="fL " style="margin-left:74px;">
				<input type="text" id="sipDomain" class="sip_text fL" value="<%=IAMEncoder.encodeHTMLAttribute(sipDomain) %>" >
			</div>
		</div>
		<div class="formelements cB fL mT20">
			<div class="fL sip_label fL cB mT5">Call Rate Prefix</div><%-- No i18n --%>
			<div class="fL" style="margin-left:28px;">
				<input type="text" id="sipCallrate" class="sip_text fL" value="<%=IAMEncoder.encodeHTMLAttribute(sipCallrate) %>" >
			</div>
		</div>
		<div class="formelements cB fL mT50">
			<input type="submit" class="primarybtn fL cB" name="Submit" value="Save" onclick="sipSave();"/>
			<!-- <button class=" sip_secbtn proxima fL mL10" onclick="sipCancel();">Cancel</button> -->
		</div>
		<div class="formelements cB fL mT50" id="sampleResponse">
			<span><%=IAMEncoder.encodeHTML(sampleSipTitle) %></span><br><br>
			<span><%=IAMEncoder.encodeHTML(sampleSipResponse) %></span>
		</div>
	</div>
</div>
</div>
<script type="text/javascript">
function sipSave()
{
	loadAjaxTab();
	var enableSip = $("#sipEnable").is(":checked");//No i18n
	var sipUsername = $("#sipUsername").val();//No i18n
	var sipPassword = $("#sipUsername").val();//No i18n
	var sipDomain = $("#sipDomain").val();//No i18n
	var sipCallrate = $("#sipCallrate").val();//No i18n
	
	var actionUrl = "/crm/TwilioSipConfig.do";//no i18n
	var dataparams = "event=add&enableSip="+enableSip+"&sipUsername="+sipUsername+"&sipPassword="+sipPassword+"&sipDomain="+sipDomain+"&sipCallrate="+sipCallrate+"&"+getCtiApicsrfParam();//No i18n
	/* var dataparams = {
			event : "add",//no i18n
			enableSip : enableSip,
			sipUsername : sipUsername,
			sipPassword : sipPassword,
			sipDomain : sipDomain,
			sipCallrate : sipCallrate
		};
	Utils.setCsrfParam(dataparams); */
	$.ajax({
		url:actionUrl,cache: false,type:"POST",data:dataparams,//No i18n 
				success: function(response)
				{
					alert("Twilio SIP parameters configured successfully");//No i18n
					Utils.showHideLoadingDiv();
				}
	});
}
</script>
</body>
</html>