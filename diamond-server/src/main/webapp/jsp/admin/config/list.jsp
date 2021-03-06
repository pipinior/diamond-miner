<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title>Diamond-Server Console</title>
    <script type="text/javascript">
        function confirmForDelete() {
            return window.confirm("Are you sure to delete the config??");
        }
        function queryConfigInfo(method) {
            document.all.queryForm.method.value = method;
            document.all.queryForm.submit();
        }

    </script>
</head>
<c:url var="adminUrl" value="/admin.do">
</c:url>
<c:if test="${method==null}">
    <c:set var="method" value="listConfig"/>
</c:if>

<body>
<c:import url="/jsp/common/message.jsp"/>
<center><h1><strong>Configuration List</strong></h1></center>
<p align='center'>

<form name="queryForm" action="${adminUrl}">
    <table align='center'>
        <tr>
            <td>dataId:</td>
            <td><input type="text" name="dataId"/></td>
            <td>group:</td>
            <td><input type="text" name="group"/></td>
            <td>
                <input type='hidden' name="pageNo" value='1'/>
                <input type='hidden' name="method" value='${method}'/>
                <input type='hidden' name="pageSize" value='15'/>
                <input type='button' value='Query' onclick="queryConfigInfo('listConfig');"/>
                <input type='button' value='Fuzzy Query' onclick="queryConfigInfo('listConfigLike');"/></td>
        </tr>
    </table>
</form>
</p>
<p align='center'>
    <c:if test="${page!=null}">
<table border='1' width="1000">
    <tr>
        <td>dataId</td>
        <td>group</td>
        <td>valid</td>
        <td>content</td>
        <td>description</td>
        <td>operations</td>
    </tr>
    <c:forEach items="${page.pageItems}" var="diamondStone">
        <tr>
            <td name="tagDataID">
                <c:out value="${diamondStone.dataId}"/>
            </td>
            <td name="tagGroup">
                <c:out value="${diamondStone.group}" escapeXml="false"/>
            </td>
            <td name="valid">
                <c:choose> <c:when test="${diamondStone.valid}">Y</c:when><c:otherwise>N</c:otherwise></c:choose>
            </td>
            <td name="content">
                <pre><c:out value="${diamondStone.content}" escapeXml="false"/></pre>
            </td>
            <td name="description">
                <pre><c:out value="${diamondStone.description}" escapeXml="false"/></pre>
            </td>
            <c:url var="getConfigInfoUrl" value="/admin.do">
                <c:param name="method" value="detailConfig"/>
                <c:param name="group" value="${diamondStone.group}"/>
                <c:param name="dataId" value="${diamondStone.dataId}"/>
            </c:url>
            <c:url var="deleteConfigInfoUrl" value="/admin.do">
                <c:param name="method" value="deleteConfig"/>
                <c:param name="id" value="${diamondStone.id}"/>
            </c:url>
            <c:url var="saveToDiskUrl" value="/notify.do">
                <c:param name="method" value="notifyConfigInfo"/>
                <c:param name="group" value="${diamondStone.group}"/>
                <c:param name="dataId" value="${diamondStone.dataId}"/>
            </c:url>
            <c:url var="previewUrl" value="/content">
                <c:param name="group" value="${diamondStone.group}"/>
                <c:param name="dataId" value="${diamondStone.dataId}"/>
            </c:url>
            <td>
                <a href="${getConfigInfoUrl}">Edit</a>&nbsp;&nbsp;&nbsp;
                <a href="${deleteConfigInfoUrl}" onclick="return confirmForDelete();">Del</a>&nbsp;&nbsp;&nbsp;
                <a href="${saveToDiskUrl}" target="_blank">Sync</a> &nbsp;&nbsp;&nbsp;
                <a href="${previewUrl}" target="_blank">Preview</a>
            </td>
        </tr>
    </c:forEach>
</table>
<p align='center'>
    Total Pages:<c:out value="${page.totalPages}"/>&nbsp;&nbsp;Current Page:<c:out value="${page.pageNo}"/>
    &nbsp;&nbsp;
    <c:url var="nextPage" value="/admin.do">
        <c:param name="method" value="${method}"/>
        <c:param name="group" value="${group}"/>
        <c:param name="dataId" value="${dataId}"/>
        <c:param name="pageNo" value="${page.pageNo+1}"/>
        <c:param name="pageSize" value="15"/>
    </c:url>
    <c:url var="prevPage" value="/admin.do">
        <c:param name="method" value="${method}"/>
        <c:param name="group" value="${group}"/>
        <c:param name="dataId" value="${dataId}"/>
        <c:param name="pageNo" value="${page.pageNo-1}"/>
        <c:param name="pageSize" value="15"/>
    </c:url>
    <c:url var="firstPage" value="/admin.do">
        <c:param name="method" value="${method}"/>
        <c:param name="group" value="${group}"/>
        <c:param name="dataId" value="${dataId}"/>
        <c:param name="pageNo" value="1"/>
        <c:param name="pageSize" value="15"/>
    </c:url>
    <c:url var="lastPage" value="/admin.do">
        <c:param name="method" value="${method}"/>
        <c:param name="group" value="${group}"/>
        <c:param name="dataId" value="${dataId}"/>
        <c:param name="pageNo" value="${page.totalPages}"/>
        <c:param name="pageSize" value="15"/>
    </c:url>
    <a href="${firstPage}">First</a>&nbsp;&nbsp;
    <c:choose>
        <c:when test="${page.pageNo==1 && page.totalPages>1}">
            <a href="${nextPage}">Next</a> &nbsp; &nbsp;
        </c:when>
        <c:when test="${page.pageNo>1 && page.totalPages==page.pageNo}">
            <a href="${prevPage}">Prev</a> &nbsp; &nbsp;
        </c:when>
        <c:when test="${page.pageNo==1 && page.totalPages==1}">
        </c:when>
        <c:otherwise>
            <a href="${prevPage}">Prev</a> &nbsp; &nbsp;
            <a href="${nextPage}">Next</a>
        </c:otherwise>
    </c:choose>
    <a href="${lastPage}">Last</a>&nbsp;&nbsp;
</p>
</c:if>
</p>
<p align='center'>
    <a href="<c:url value='/jsp/admin/config/new.jsp' />">New Config</a> &nbsp;&nbsp;&nbsp;&nbsp;
    <a href=" <c:url value='/jsp/admin/config/upload.jsp' />">Upload Config</a>
</p>
</body>
</html>