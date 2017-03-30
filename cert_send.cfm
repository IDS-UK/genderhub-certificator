
<cfparam name="url.set_name" default="" />
<cfparam name="url.download_folder" default="" />

<cfif url.set_name NEQ ""><!--- perform creation if set_name is not blank --->

	<!--- ########## Set the params begin ########## --->
	<cfset friendly_course_name = "Engaging men towards gender equality: why and how should we do it?"> <!--- this is used in the email --->
	<cfset cert_suffix = "_certificate">						<!--- Only used if you changes the cert_suffix in the generation stage --->
	<cfset cert_download_folder = "#url.download_folder#">		<!--- Folder of stored certificate used to generate url for download (certs must be uploaded to GenderHub) --->
	<cfset cert_set_name = "#url.set_name#">					<!--- Used to select dataset from DB for sending --->
	<cfset test_mode = 1>										<!--- 1 = true, 0 = false --->
	<!--- ########## Set the params finish ########## --->
	
	<cfif test_mode IS 1><!--- test mode is true so set max_rows to 3 --->
		<cfset max_rows = 3>
	<cfelse><!--- set to a small number to test or 99999 when sending live  --->	
		<cfset max_rows = 999999>
	</cfif>
	
	<cfquery name="getPeople" datasource="certificates">
	SELECT [uid]
	      ,[set_name]
	      ,[name]
	      ,[email]
	      ,[folder]
	      ,[date_added]
	      ,[status]
	  FROM [certificates].[dbo].[people]
	  WHERE set_name = '#cert_set_name#'
	</cfquery>
	
				<cfif test_mode IS 1><!--- test mode is true so set variables --->
					<cfset sendtestto = "s.tovell@ids.ac.uk;a.bannister@ids.ac.uk;r.jeffrey@ids.ac.uk"><!---  --->
					<cfset sendbcc = "">
					<cfset sendprefix = "TEST: ">
					<cfset screenmessage = "You are currently in test mode so Emails will not be sent to recepients. Instead <strong style='color: red;'>" & max_rows & "</cfoutput></strong> test emails will be sent to: " & sendtestto & ".">
				<cfelse>
					<cfset sendbcc = "info@genderhub.org">
					<cfset sendprefix = "">
					<cfset screenmessage = "You are currently in live mode!<br />Emails *will* be sent to all recepients!">
				</cfif>
	
	<cfif NOT isDefined("url.yesplease")>
	
		<div style="margin: auto; width: 90%; padding-top: 50px">
			<h1 style="text-align: center;"><cfoutput>#getPeople.recordcount#</cfoutput> recepients in currrent data set <br />(<cfoutput>#url.set_name#</cfoutput>)</h1>
			<p style="text-align: center; font-size: 1.3em; font-weight: bold; font-family: calibri;">Would you like to send out the certificate notification to all the people who compelted the course now?</p>
			<cfoutput>
			<p style="font-size: 8em; font-weight: bold; font-family: calibri; text-align: center; padding: 0; margin: 0; color: grey;"><a href="?yesplease=true&set_name=#url.set_name#&download_folder=#url.download_folder#" style="text-decoration: none; color: green;">Yes</a>/<a href="http://www.disney.co.uk/" style="text-decoration: none; color: red;">No</a></p>
			</cfoutput>
			<p style="text-align: center; font-size: 1.4em; font-family: calibri; color: #F97878;">
			<cfoutput>#screenmessage#</cfoutput>
			</p>
		</div>
	
	<cfelse>
	
		<h1>Here we go:</h1>
			<cfoutput query="getPeople" maxrows="#max_rows#">
	
				<cfif test_mode IS 1><!--- test mode is true so send to test email addresses --->
					<cfset sendto = sendtestto>
					<cfset sendsuffix = " (" & email & ")">
				<cfelse>
					<cfset sendto = email>
					<cfset sendsuffix = "">
				</cfif>
				
				<cfmail to="#sendto#" bcc="#sendbcc#" from="info@genderhub.org" subject="#sendprefix# Your Gender Hub elearning course completion certificate#sendsuffix#" type="html"><!--- BCC to adrian until cert re-issues can be done from interface --->
				<font face="Calibri,Arial,Veranda">
				Dear #name#,
				<p>Congratulations! You have completed all four lessons in our e-learning course '#friendly_course_name#'.</p>
				<p>We are therefore delighted to be able to present you with a certificate of completion - please download it at: <a href="http://www.genderhub.org/#cert_download_folder#/#trim(replacelist(email,"@,.,_,-",",,,"))##cert_suffix#.pdf">http://www.genderhub.org/#cert_download_folder#/#trim(replacelist(email,"@,.,_,-",",,,"))##cert_suffix#.pdf</a></p>
				<p>This certificate is jointly presented by the Voices for Change, Nigeria programme and the Institute of Development Studies (IDS), UK.</p>
				<p>We hope you enjoyed the course - if you would like to hear from us about future opportunities please subscribe to our email updates at: <a href="http://www.genderhub.org/subscribe">www.genderhub.org/subscribe</a> and also stay in touch via our social media channels below.</p>
				<p>
				Kind regards<br />
				Steve Tovell, on behalf of the Gender Hub e-learning team
				</p>
	
				<hr style="color: black 1px solid;" color="grey" />
				Gender Hub<br />
				Part of Voices for Change, Nigeria and funded by UKAID<br />
				Web: http://www.genderhub.org<br />
				Email: <a href="mailto:info@genderhub.org">info@genderhub.org</a> <br />
				<br />
				Follow us on Twitter: <a href="https://twitter.com/Gender_Hub">@Gender_Hub</a><br />
				Follow us on Facebook: <a href="http://www.facebook.com/GenderHubNigeria">facebook.com/GenderHubNigeria</a>
				<hr style="color: black 1px solid;" color="grey" />
				</font>
				</cfmail>
				
				A mail was sent to: #email#<br />
			</cfoutput>
	
	</cfif>
	
	
	<!--- 
	
				SUBJECT: Your Gender Hub elearning course completion certificate
	
				Dear #name#,
				<p>Congratulations! You have now completed all four of the lessons in our 'Gender Stereotypes: How Can We Move Beyond Stereotyping?' course.</p>
				<p>We are therefore delighted to be able to present you with a certificate of completion - please download it at: <a href="http://www.genderhub.org/certs/#trim(replacelist(email,"@,.,_,-",",,,"))##cert_suffix#.pdf">http://www.genderhub.org/certs/#trim(replacelist(email,"@,.,_,-",",,,"))##cert_suffix#.pdf</a></p>
				<p>This certificate is jointly presented by the Voices for Change, Nigeria programme and the Institute of Development Studies (IDS), UK.</p>
				<p>We hope you enjoyed the course - if you would like to hear from us about future opportunities please subscribe to our email updates at: <a href="http://www.genderhub.org/subscribe">www.genderhub.org/subscribe</a></p>
				<p>
				Warm regards<br />
				Adrian Bannister, on behalf of the Gender Hub e-learning team
				</p>
	
				<hr style="color: black 1px solid;" color="grey" />
				Gender Hub<br />
				Part of Voices for Change, Nigeria and funded by UKAID<br />
				Web: http://www.genderhub.org<br />
				Email: info@genderhub.org <br />
				<br />
				Follow us on Twitter: @Gender_Hub
	 --->

<cfelse>
	Something went wrong :(
	<a href="javascript:history.go(-1)">Back</a>
</cfif>