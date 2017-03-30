
<cfparam name="url.cert_pdf" default="" />
<cfparam name="url.set_name" default="" />
<cfparam name="url.download_folder" default="" />

<cfif url.cert_pdf NEQ ""><!--- perform creation if pdf cert not blank --->

	<!--- set the params --->
	<cfset cert_template = "#url.cert_pdf#">				<!--- name of PDF certificate (Form) --->
	<cfset cert_download_folder = "#url.download_folder#">	<!--- folder to put certificates (created if it doesn't exist --->
	<cfset cert_set_name = "#url.set_name#">				<!--- Set name in the [certificates] database [people] table [set_name] column --->
	<cfset cert_suffix = "_certificate">
	<cfset form_field_name = "Name">
	
	<!--- create the folder for certs --->
	<cfif NOT DirectoryExists(#getDirectoryFromPath(getCurrentTemplatePath())# & #cert_download_folder#)>
		<cfdirectory action="create" directory="#getDirectoryFromPath(getCurrentTemplatePath())##cert_download_folder#">
	</cfif>
	
	
	<cfquery name="getPeople" datasource="certificates">
	SELECT [uid]
	      ,[set_name]
	      ,[name]
	      ,[email]
	      ,[folder]
	      ,[date_added]
		  ,[date_generated]
	      ,[status]
	  FROM [certificates].[dbo].[people]
	  WHERE set_name = '#cert_set_name#'
	</cfquery>
	
	<table>
		<tr>
			<th>Name</th>
			<th>Email</th>
			<th>Cert Name (link)</th>
		</tr>
	
	<cfoutput query="getPeople">
	
		<tr>
			<td>#name#</td>
			<td>#email#</td>
			<td><a href="#cert_download_folder#/#trim(replacelist(email,"@,.,_,-",",,,"))##cert_suffix#.pdf">#trim(replacelist(email,"@,.,_,-",",,,"))##cert_suffix#.pdf</a></td>
		</tr>
		
		<cfpdfform action = "populate"
		    source = "#getDirectoryFromPath(getCurrentTemplatePath())##cert_template#"
		    destination = "#getDirectoryFromPath(getCurrentTemplatePath())##cert_download_folder#/#trim(replacelist(email,"@,.,_,-",",,,"))##cert_suffix#.pdf"
		    overwrite = "yes">
				<cfpdfformparam name="#form_field_name#" value="#name#">
		</cfpdfform>
		
		<!--- make read-only --->
		<cfpdf action = "write"
		       source = "#getDirectoryFromPath(getCurrentTemplatePath())##cert_download_folder#/#trim(replacelist(email,"@,.,_,-",",,,"))##cert_suffix#.pdf"
		       destination = "#getDirectoryFromPath(getCurrentTemplatePath())##cert_download_folder#/#trim(replacelist(email,"@,.,_,-",",,,"))##cert_suffix#.pdf"
		       flatten = "yes"
		       overwrite = "yes"  />
		   
			<!--- writes the date the PDF was generated --->
			<cfquery name="writeGenDate" datasource="certificates">
			UPDATE [certificates].[dbo].[people]
			SET [date_generated] = '#dateformat(now(),"yyyy-mm-dd")# #timeformat(now(),"hh:mm:00")#'
			WHERE UID = #getPeople.uid#
			</cfquery>
		   
	</cfoutput>
	
	</table>
<cfelse>
	Select a certificate!
	<a href="javascript:history.go(-1)">Back</a>
</cfif>