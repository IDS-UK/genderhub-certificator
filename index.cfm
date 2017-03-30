
<cfparam name="pageTitle" default="Home">
<cfinclude template="pageHeader.cfm" />

<cfif isDefined("url.GetSet")>

	<cfquery name="getPeople" datasource="certificates">
		SELECT uid, set_name, name, email, folder, date_added, date_sent, status, date_generated 
		FROM people
		WHERE set_name = '#trim(url.GetSet)#'
		ORDER BY name ASC
	</cfquery>

	<cfif getPeople.status IS 0>
	
		<cfif len(getPeople.date_generated) IS 0>
			<!--- form to select PDF template to generate certificates --->
			<form name="generate_certs" id="generate_certs" action="cert_create.cfm" method="get" class="pure-form pure-form-aligned" style="margin-top: 20px;">
				<div class="pure-control-group">
					<select name="cert_pdf" id="cert_pdf">
						<option value="">Select PDF Template</option>
						<cfdirectory action="list" directory="#getDirectoryFromPath(getCurrentTemplatePath())#" filter="*.pdf" name="cert_files" sort="datelastmodified desc">
						
						<cfoutput query="cert_files">
							<option value="#cert_files.name#">#cert_files.name#</option>
						</cfoutput>
					</select>
					
				<cfoutput>
					<input type="hidden" name="set_name" id="set_name" value="#getPeople.set_name#">
					<input type="hidden" name="download_folder" id="download_folder" value="#getPeople.folder#">
				</cfoutput>
					<input type="submit" name="submit" id="submit" value="Generate Certificates" class="pure-button pure-button-primary">
				</div>
			</form>
		<cfelse>
			<form name="send_certs" id="send_certs" action="cert_send.cfm" method="get" class="pure-form pure-form-aligned" style="margin-top: 20px;">
			<div class="pure-control-group">
				<cfoutput>
				<input type="hidden" name="set_name" id="set_name" value="#getPeople.set_name#">
				<input type="hidden" name="download_folder" id="download_folder" value="#getPeople.folder#">
				</cfoutput>
				<input type="submit" name="submit" id="submit" value="Send Certificates Screen" class="pure-button pure-button-primary">
			</div>
			</form>
		</cfif>

	</cfif>
	
	<div>
	<table id="dataTable">
	<thead>
		<tr>
			<th>Set Name</th>
			<th>Name</th>
			<th>Email</th>
			<th>Folder</th>
			<th>Date Loaded</th>
			<cfif getPeople.status IS 1><th>Date Sent</th></cfif>
		</tr>
	</thead>
	<tbody>
		<cfset LoopC = 1>
		<cfoutput query="getPeople">
			<tr class="<cfif BitAnd( LoopC, 1 )>lgrey<cfelse>dgrey</cfif>">
				<td>#set_name#</td>
				<td>#name#</td>
				<td>#email#</td>
				<td>#folder#</td>
				<td>#dateformat(date_added,"dd/mm/yy")# #timeformat(date_added,"HH:mm")#</td>
				<cfif getPeople.status IS 1><td>#dateformat(date_sent,"dd/mm/yy")# #timeformat(date_sent,"HH:mm")#</td></cfif>
			</tr>
			<cfset LoopC = LoopC + 1>
		</cfoutput>
	</tbody>
	</table>
	</div>
<cfelse>

	<cfparam name="form.set_name" default="">
	<cfparam name="form.new_upload" default="">

	<cfif len(form.set_name) IS 0 OR len(form.new_upload) IS 0>

		<fieldset class="form-outer-fieldset">
			<legend>Add New Data Set</legend>
			
			<form name="add_set" id="add_set" method="post" enctype="multipart/form-data" class="pure-form pure-form-aligned">
				<div class="pure-control-group">
					<label for="set_name">Set Name</label>
					<cfoutput><input type="text" name="set_name" id="set_name" placeholder="Set Name" value="#form.set_name#"></cfoutput>
					(Choose a short descriptive unique name) <cfif cgi.request_method IS "POST" AND len(form.set_name) IS 0><span class="error">Opps!</span></cfif>
				</div>
				<div class="pure-control-group">
					<label for="new_upload">CSV Upload</label>
					<cfoutput><input type="file" name="new_upload" id="new_upload" size="50" maxlength="255" placeholder="CSV Upload" class="pure-button" value="#form.new_upload#"> <cfif cgi.request_method IS "POST" AND len(form.new_upload) IS 0><span class="error">Opps!</span></cfif></cfoutput>
				</div>
				<div class="pure-controls">
					<input type="submit" name="submit" id="submit" value="Add Set" class="pure-button pure-button-primary">
				</div>
			</form>
		
		</fieldset>

	<cfelse>
	
		<!--- Checks if set already exists with name and loops adding a number to the name until it finds a unique one --->
		<cfset IncNum = 1>
		<cfset checkName = form.set_name>
		<cfloop condition = "checkIfSetExists(checkName) IS TRUE">
			<cfset checkName = form.set_name & IncNum>
			<cfset IncNum = IncNum + 1>
		</cfloop>
		
		<cfset uploadName = dateformat(now(),"yyyy-mm-dd") & "--" & timeformat(now(),"hh-mm-ss") & ".csv">
		<!--- upload file --->
		<cffile action="upload" fileField="new_upload" destination="#getDirectoryFromPath(getCurrentTemplatePath())##uploadName#" nameConflict="overwrite">

		<!--- loop through CSV and add to database --->
		<cfset LoopC = 0>
		<cfset LoadCount = 0>
		
			<cfloop index="line" file="#getDirectoryFromPath(getCurrentTemplatePath())##uploadName#">
					<cfset LoopC = LoopC + 1>
					<cfoutput>
						<cftry>
							<cfif listlen(line) GTE 2>
								<cfif find(chr(34),line) NEQ 0>
									<cfset aryNames = "#rematch("#chr(34)#.*#chr(34)#",line)#">
									<div style="color: red;"></div>
										<cfquery name="insertPerson" datasource="certificates">
										INSERT INTO [certificates].[dbo].[people]
										([set_name]
										,[name]
										,[email]
										,[folder]
										,[date_added]
										,[status])
										VALUES
										('#checkName#'
										,'#replace(aryNames[1],"#chr(34)#","","all")#'
										,'#reverse(listgetat(reverse(line),1))#'
										,'certs#dateformat(now(),"yymm")#'
										,'#dateformat(now(),"yyyy-mm-dd")# #timeformat(now(),"HH:MM:SS")#'
										,0)
										</cfquery>
								<cfelse>
										<cfquery name="insertPerson" datasource="certificates">
										INSERT INTO [certificates].[dbo].[people]
										([set_name]
										,[name]
										,[email]
										,[folder]
										,[date_added]
										,[status])
										VALUES
										('#checkName#'
										,'#trim(listgetat(line,1))#'
										,'#trim(listgetat(line,2))#'
										,'certs#dateformat(now(),"yymm")#'
										,'#dateformat(now(),"yyyy-mm-dd")# #timeformat(now(),"HH:MM:SS")#'
										,0)
										</cfquery>
								</cfif>
								
								<cfset LoadCount = LoadCount + 1>
							
							<cfelse>
								<div>Error loading line #LoopC#: #line#</div>
							</cfif>
							<cfcatch type="any">
								#cfcatch.detail#
								<div>Error loading line #LoopC#: #line# CATCH</div>
							</cfcatch>
						</cftry>
					</cfoutput>
			</cfloop>
	
		<cfoutput>
		<p>#LoadCount# people added to the set: <a href="?GetSet=#checkName#">#checkName#</a> has been added to the system :)</p>
		</cfoutput>
	</cfif>
	
</cfif>

<cfinclude template="pageFooter.cfm" />