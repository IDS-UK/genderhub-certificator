<cffunction name="getSetDate" returntype="date" access="public">
	<cfargument name="thissetname" type="string" required="yes">

	<cfquery name="getSetByName" datasource="certificates">
		SELECT TOP 1 date_added 
		FROM people 
		WHERE set_name = '#arguments.thissetname#' 
	</cfquery>

	<cfreturn getSetByName.date_added>
</cffunction>

<cffunction name="checkIfSetExists" returntype="boolean" access="public">
	<cfargument name="thissetname" type="string" required="yes">

	<cfquery name="getSetByName" datasource="certificates">
		SELECT TOP 1 date_added 
		FROM people 
		WHERE set_name = '#arguments.thissetname#' 
	</cfquery>

	<cfif getSetByName.recordcount IS 1>
		<cfset doesExist = true>
	<cfelse>
		<cfset doesExist = false>
	</cfif>
	
	<cfreturn doesExist>
</cffunction>