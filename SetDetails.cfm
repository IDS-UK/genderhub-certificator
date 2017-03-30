
<cfparam name="pageTitle" default="Set Details (#url.action#)">
<cfinclude template="pageHeader.cfm" />

<cfparam name="form.admin_emails" default="">
<cfparam name="form.domain" default="">
<cfparam name="form.pdf_upload" default="">
<cfparam name="form.email_template" default="">

	<cfquery name="getCertificates" datasource="certificates">
		SELECT [uid],[cert_path],[cert_domain],[admin_email],[email_template],[set_name]
		FROM certificates 
		WHERE set_name = '#trim(url.GetSet)#'
	</cfquery>

	<div>
		<cfoutput>
		<fieldset class="form-outer-fieldset">
			<legend>Set Details (#url.action#)</legend>
			<form name="add_set_details" id="add_set_details" action="?GetSet=#url.GetSet#&action=#url.action#" method="post" enctype="multipart/form-data" class="pure-form pure-form-aligned">
				<input type="hidden" name="asas" value="122212">
				<div class="pure-control-group">
					<label for="admin_emails">Admin Email(s)</label>
					<input type="text" name="admin_emails" id="admin_emails" placeholder="Admin Email(s)" value="#form.admin_emails#">
					(Seperate email addresses with a semi-colon)
				</div>
				<div class="pure-control-group">
					<label for="domain">Domain</label>
					<input type="text" name="domain" id="domain" placeholder="http://www.example.com" value="#form.domain#">
					(Domain where the certificate will be downloaded from)
				</div>
				<div class="pure-control-group">
					<label for="pdf_upload">Certificate PDF</label>
					<input type="file" name="pdf_upload" id="pdf_upload" size="50" maxlength="255" placeholder="PDF Upload" class="pure-button">
					#form.pdf_upload# (overwrite message)
				</div>
				<div class="pure-control-group">
					<label for="email_template">Email Template</label>
					<textarea name="email_template" id="email_template" placeholder="Email Template" style="width: 75%; height: 450px;">#email_template#</textarea>
				</div>
				<div class="pure-controls">
					<input type="submit" name="submit" id="submit" value="Add Details" class="pure-button pure-button-primary">
				</div>
			</form>
		</fieldset>
		</cfoutput>
	</div>

<cfinclude template="pageFooter.cfm" />