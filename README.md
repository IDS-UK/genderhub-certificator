# genderhub-certificator
A Coldfusion/SQL application for the production of elearning course certificates


This application is a work in progress and while it functions it invoves manual steps where access 
to the server source files is needed.

This application was created and fully tested on Coldfusion Version 8, however it should work in 
all newer versions of Coldfusion as well as Railo or Lucee.

The database used was Microsoft SQL 
Server 2008 R2 however should work with all versions of SQL including MySQL though the script to 
created the People table may not work in MySQL so that would need to be done manually.

The code has only been tested on Windows so if running on Linux code changes may need to be made.


Installation
============

1. Copy zip contents to either the webroot of a new site on your webserver or into a new sub 
   folder of an existing webroot.

2. Create a new database called certificates in SQL Server and run the provided script to create 
   the table "people".

3. Set-up a datasource in the Coldfusion administrator called "certificates" pointing at your new 
   database.
