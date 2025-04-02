<?xml version='1.0' encoding='ASCII' ?>
<Velocity11 file='Protocol_Data' md5sum='951a80367f34d27fa97fc0a7e86dc5a1' version='2.0' >
	<File_Info AllowSimultaneousRun='1' AutoExportGanttChart='0' AutoLoadRacks='When the main protocol starts' AutoUnloadRacks='0' AutomaticallyLoadFormFile='1' Barcodes_Directory='' ClearInventory='0' DeleteHitpickFiles='1' Description='' Device_File='C:\VWorks Workspace\Metabolomics\Device File\96LT w Vac Flt Stn_v4.dev' Display_User_Task_Descriptions='1' DynamicAssignPlateStorageLoad='0' FinishScript='' Form_File='C:\VWorks Workspace\Metabolomics\Form File\QCPool.VWForm' HandlePlatesInInstance='1' ImportInventory='0' InventoryFile='' Notes='' PipettePlatesInInstanceOrder='0' Protocol_Alias='' StartScript='' Use_Global_JS_Context='1' />
	<Processes >
		<Startup_Processes >
			<Process >
				<Minimized >0</Minimized>
				<Task Name='BuiltIn::JavaScript' >
					<Enable_Backup >0</Enable_Backup>
					<Task_Disabled >0</Task_Disabled>
					<Task_Skipped >0</Task_Skipped>
					<Has_Breakpoint >0</Has_Breakpoint>
					<Advanced_Settings >
						<Setting Name='Estimated time' Value='0' />
					</Advanced_Settings>
					<TaskScript Name='TaskScript' Value='function getWellselection (well,plateType) {
	// This function converts a well coordinate in the form of &quot;A1&quot;, &quot;P24&quot;, &quot;AC13&quot;, etc 
	// into a vector (not a vector of vectors!) e.g. [1,1], [3,12], etc: [row,col]
	// also useful for checking if the well code is correct.
	// It converts the coordinates to uppercase and removes all spaces. 
	// plateType can be 6, 12, 24, 48, 96, 384 and 1536.
	// plateType defaults to 96 if undefined.
	// Version 1.0.1
	// Mauro Cremonini - Agilent - March 2019
	// Apr 2019 - modified regexp for filtering all but letters and numbers in coord 
	//            useful when one forgets quotes or double quotes around strings in csv
	//			Added possibility of asking for current version. 
	// Jul 2019 - v 1.0.2 added support for 54 well plates
	// Mar 2020 - v 1.0.3 fixed issue met when passing platype as string 
	
	//print(&quot;getWellselection: received well = &quot;+ well +&quot;, plateType = &quot; + plateType)
	
	var version = &quot;1.0.3 - Mar 2020&quot;
	
    // if plateType is “undefined” default to 96
	var plateType = Number(plateType) || 96
	var well = well
	if (well === undefined) {
		print(&quot;Error: well is undefined!&quot;) 
		return false
	}

	// if well contains &quot;version&quot; return current version
	if (well === &quot;current_version&quot;) return version

	// in the part below the “switch” construct behaves like a series of if … else if … else statements
	// and sets rowH and colH to the maximum number of rows and columns for each tested plateType
	switch (plateType) {
		case 6:
			var rowH = 2
			var colH = 3
        break
		case 12:  
			var rowH = 3
			var colH = 4
		break
		case 24: 
			var rowH = 4
			var colH = 6
		break
		case 48:
			var rowH = 6
			var colH = 8
		break
		case 54:
			var rowH = 6
			var colH = 9
		break
		case 96:
			var rowH = 8
			var colH = 12
		break
		case 384:
			var rowH = 16
			var colH = 24
		break
		case 1536:
			var rowH = 32
			var colH = 48
		break
		default:
			print(&quot;Error: plateType is set to &quot; + plateType)
			print(&quot;Wrong plate type selection in getWellselection&quot;)
		return false
	}
	// turn all caps to big and strip spaces
	var coord = well.toUpperCase().replace(/[^A-Za-z0-9]/g,&apos;&apos;)
	// subtract 64 from ASCII codes of the first and second char
	var test1 = coord.charCodeAt(0) - 64
	var test2 = coord.charCodeAt(1) - 64
	if (test1 &gt;= 1 &amp;&amp; test1 &lt;= 6 &amp;&amp; test2 &gt;= 1 &amp;&amp; test2 &lt;= 6) {
		// first and second chars are A to F so it is 1536-type coord
		// so add 26 to find row number
		// col begins at column 3
		var row = 26 + test2
		var col = coord.substring(2) 
	}
	else {
		// any other plate
		var row = test1
		var col = coord.substring(1)
	}
	// make sure that row and col are numbers
	// default to zero if “NaN” (not a number)
	row = Number(row) || 0
	col = Number(col) || 0
	//print(&quot;Found: row = &quot; + row + &quot;, col = &quot; + col) 
	// safety check: are row and col meaningful for current plateTyle
	if (row &gt; 0 &amp;&amp; row &lt;= rowH &amp;&amp; col &gt; 0 &amp;&amp; col &lt;= colH) {
		return [row,col] // returning a vector ok
	}
	else {
		print(&quot;Warning: well &quot; + coord + &quot; is out of range for the selected plate type&quot;) 
		return false // conversion failed
	}   
}


function myLog(text, myFile, flag) {
   var f = new File()
   f.Open(myFile, flag)
   f.Write(text+&quot;\n&quot;)
   f.Close()
   return text
}

function getTimeStamp () {
   //creating timestamp
   var myDate = new Date()
   var myYr = myDate.getFullYear()
   var myMo = (&quot;0&quot;+(myDate.getMonth() + 1)).slice(-2)
   var myDy = (&quot;0&quot;+myDate.getDate()).slice(-2)
   var myHr = (&quot;0&quot;+myDate.getHours()).slice(-2)
   var myMn = (&quot;0&quot;+myDate.getMinutes()).slice(-2)
   var mySc = (&quot;0&quot;+myDate.getSeconds()).slice(-2)

   var myTimeStamp =  myYr+myMo+myDy+&quot;_&quot;+myHr+myMn+mySc
   return(myTimeStamp)
}

// alert sound (using powershell)
function alert() {
    //run(&quot;powershell [System.Console]::Beep(1864.7,75),[System.Console]::Beep(1568,75),[System.Console]::Beep(1174.7,150)&quot;) // mission impossible!
	run(&quot;powershell [System.Console]::Beep(1046.6,75),[System.Console]::Beep(880,75),[System.Console]::Beep(932.4,75)&quot;)
    //run(&quot;powershell [System.Media.SystemSounds]::Hand.play()&quot;)  
}


' />
					<Parameters >
						<Parameter Category='Task Description' Name='Task number' Value='1' />
						<Parameter Category='Task Description' Name='Task description' Value='functions' />
						<Parameter Category='Task Description' Name='Use default task description' Value='0' />
					</Parameters>
				</Task>
				<Task Name='BuiltIn::JavaScript' >
					<Enable_Backup >0</Enable_Backup>
					<Task_Disabled >0</Task_Disabled>
					<Task_Skipped >0</Task_Skipped>
					<Has_Breakpoint >0</Has_Breakpoint>
					<Advanced_Settings >
						<Setting Name='Estimated time' Value='0' />
					</Advanced_Settings>
					<TaskScript Name='TaskScript' Value='//open(&quot;C:/VWorks Workspace/VWorksExtLib/vworksextlib.js&quot;)


formInfo = &quot;&quot;

' />
					<Parameters >
						<Parameter Category='Task Description' Name='Task number' Value='2' />
						<Parameter Category='Task Description' Name='Task description' Value='JavaScript' />
						<Parameter Category='Task Description' Name='Use default task description' Value='1' />
					</Parameters>
				</Task>
				<Task Name='BuiltIn::Configure Labware' >
					<Devices >
						<Device Device_Name='Agilent Bravo - 1' Location_Name='' />
					</Devices>
					<Enable_Backup >0</Enable_Backup>
					<Task_Disabled >0</Task_Disabled>
					<Task_Skipped >0</Task_Skipped>
					<Has_Breakpoint >0</Has_Breakpoint>
					<Advanced_Settings />
					<TaskScript Name='TaskScript' Value='' />
					<Parameters >
						<Parameter Category='' Name='Device to use' Value='Agilent Bravo - 1' />
						<Parameter Category='' Name='Display confirmation' Value='' />
						<Parameter Category='' Name='1' Value='' />
						<Parameter Category='' Name='2' Value='' />
						<Parameter Category='' Name='3' Value='' />
						<Parameter Category='' Name='4' Value='' />
						<Parameter Category='' Name='5' Value='' />
						<Parameter Category='' Name='6' Value='24-well 1.5 mL Eppendorf tube as a 24' />
						<Parameter Category='' Name='7' Value='' />
						<Parameter Category='' Name='8' Value='96 V11 LT250 Tip Box Standard' />
						<Parameter Category='' Name='9' Value='96 V11 LT250 Tip Box Standard' />
						<Parameter Category='Task Description' Name='Task number' Value='3' />
						<Parameter Category='Task Description' Name='Task description' Value='Configure Labware' />
						<Parameter Category='Task Description' Name='Use default task description' Value='0' />
					</Parameters>
				</Task>
				<Task Name='BuiltIn::Load Data File 2' >
					<Enable_Backup >0</Enable_Backup>
					<Task_Disabled >0</Task_Disabled>
					<Task_Skipped >0</Task_Skipped>
					<Has_Breakpoint >0</Has_Breakpoint>
					<Advanced_Settings >
						<Setting Name='Estimated time' Value='0' />
					</Advanced_Settings>
					<TaskScript Name='TaskScript' Value='' />
					<Parameters >
						<Parameter Category='Property 1' Name='Property name' Value='name' />
						<Parameter Category='Property 2' Name='Property name' Value='sWell' />
						<Parameter Category='Property 3' Name='Property name' Value='vol' />
						<Parameter Category='Property 4' Name='Property name' Value='...' />
						<Parameter Category='Property 5' Name='Property name' Value='...' />
						<Parameter Category='Property 6' Name='Property name' Value='...' />
						<Parameter Category='Property 7' Name='Property name' Value='...' />
						<Parameter Category='Property 8' Name='Property name' Value='...' />
						<Parameter Category='Property 1' Name='Column number' Value='1' />
						<Parameter Category='Property 2' Name='Column number' Value='2' />
						<Parameter Category='Property 3' Name='Column number' Value='3' />
						<Parameter Category='Property 4' Name='Column number' Value='...' />
						<Parameter Category='Property 5' Name='Column number' Value='...' />
						<Parameter Category='Property 6' Name='Column number' Value='...' />
						<Parameter Category='Property 7' Name='Column number' Value='...' />
						<Parameter Category='Property 8' Name='Column number' Value='...' />
						<Parameter Category='Input' Name='File name' TaskParameterScript='=inputFile' Value='C:\Users\supandor\OneDrive - Agilent Technologies\Documents\Jesper example.csv' />
						<Parameter Category='Input' Name='Separator' Value=',' />
						<Parameter Category='Input' Name='Debug' Value='0' />
						<Parameter Category='Input' Name='Skip header' Value='1' />
						<Parameter Category='Input' Name='Rows to ignore' Value='1' />
						<Parameter Category='Output' Name='Array name' Value='myPlates' />
						<Parameter Category='Info' Name='Author' Value='Mauro Cremonini - Agilent' />
						<Parameter Category='Info' Name='Version' Value='2.0.2' />
						<Parameter Category='Info' Name='Date' Value='Apr 2019' />
						<Parameter Category='Task Description' Name='Task number' Value='4' />
						<Parameter Category='Task Description' Name='Task description' Value='Load Data File 2' />
						<Parameter Category='Task Description' Name='Use default task description' Value='1' />
					</Parameters>
				</Task>
				<Task Name='BuiltIn::JavaScript' >
					<Enable_Backup >0</Enable_Backup>
					<Task_Disabled >0</Task_Disabled>
					<Task_Skipped >0</Task_Skipped>
					<Has_Breakpoint >0</Has_Breakpoint>
					<Advanced_Settings >
						<Setting Name='Estimated time' Value='0' />
					</Advanced_Settings>
					<TaskScript Name='TaskScript' Value='var nPlates = myPlates.length
var iDest = -1 // Counter for destinations -- this will be zero-based 
var destWells = 48, tmpDest, destName
var poolVol = Number(volume)
var outFile = &quot;C:/VWorks Workspace/Sufyan/Output/Output_&quot;+getTimeStamp()+&quot;.csv&quot;
var tipsCapacity = 250
var header = &quot;Source Plate,Source Well,Destination Plate,Destination Well,Volume,Pool Plate Well,Pool Volume&quot;

var error = false
// check for volume overflow
for (i = 0; i &lt; nPlates; i++) {
   for (j = 0; j &lt; myPlates[i].items; j++) {
      if (Number(myPlates[i].vol[j]) + poolVol &gt; tipsCapacity) {error = true;break}
   }
}

if (!error) {
   myLog(header,outFile,true)
   formInfo = &quot;Please check the tip state editor&quot;
   task.pause()
}' />
					<Parameters >
						<Parameter Category='Task Description' Name='Task number' Value='5' />
						<Parameter Category='Task Description' Name='Task description' Value='JavaScript' />
						<Parameter Category='Task Description' Name='Use default task description' Value='1' />
					</Parameters>
				</Task>
				<Plate_Parameters >
					<Parameter Name='Plate name' Value='startup process - 1' />
				</Plate_Parameters>
				<Quarantine_After_Process >0</Quarantine_After_Process>
			</Process>
		</Startup_Processes>
		<Main_Processes >
			<Process >
				<Minimized >0</Minimized>
				<Task Name='BuiltIn::Process Control' >
					<Enable_Backup >0</Enable_Backup>
					<Task_Disabled >0</Task_Disabled>
					<Task_Skipped >0</Task_Skipped>
					<Has_Breakpoint >0</Has_Breakpoint>
					<Advanced_Settings />
					<TaskScript Name='TaskScript' Value='' />
					<Parameters >
						<Parameter Category='' Name='Process to trigger option 1' Value='source' />
						<Parameter Category='' Name='Process to trigger option 2' Value='abort' />
						<Parameter Category='' Name='Process to trigger option 3' Value='N/A' />
						<Parameter Category='' Name='Process to trigger option 4' Value='N/A' />
						<Parameter Category='' Name='Process to trigger option 5' Value='N/A' />
						<Parameter Category='' Name='Process to trigger option 6' Value='N/A' />
						<Parameter Category='' Name='Process to trigger option 7' Value='N/A' />
						<Parameter Category='' Name='Process to trigger option 8' Value='N/A' />
						<Parameter Category='' Name='Process to trigger option 9' Value='N/A' />
						<Parameter Category='' Name='Process as subroutine' Value='' />
						<Parameter Category='' Name='Process selection value' TaskParameterScript='=1+error' Value='1' />
						<Parameter Category='' Name='Process variable name' Value='' />
						<Parameter Category='' Name='Spawn parameter' Value='' />
					</Parameters>
				</Task>
				<Plate_Parameters >
					<Parameter Name='Plate name' Value='check' />
					<Parameter Name='Plate type' Value='' />
					<Parameter Name='Simultaneous plates' Value='1' />
					<Parameter Name='Plates have lids' Value='0' />
					<Parameter Name='Plates enter the system sealed' Value='0' />
					<Parameter Name='Use single instance of plate' Value='0' />
					<Parameter Name='Automatically update labware' Value='0' />
					<Parameter Name='Enable timed release' Value='0' />
					<Parameter Name='Release time' Value='30' />
					<Parameter Name='Auto managed counterweight' Value='0' />
					<Parameter Name='Barcode filename' Value='No Selection' />
					<Parameter Name='Has header' Value='' />
					<Parameter Name='Barcode or header South' Value='No Selection' />
					<Parameter Name='Barcode or header West' Value='No Selection' />
					<Parameter Name='Barcode or header North' Value='No Selection' />
					<Parameter Name='Barcode or header East' Value='No Selection' />
				</Plate_Parameters>
				<Quarantine_After_Process >0</Quarantine_After_Process>
			</Process>
			<Process >
				<Minimized >0</Minimized>
				<Task Name='BuiltIn::User Message' >
					<Enable_Backup >0</Enable_Backup>
					<Task_Disabled >0</Task_Disabled>
					<Task_Skipped >0</Task_Skipped>
					<Has_Breakpoint >0</Has_Breakpoint>
					<Advanced_Settings >
						<Setting Name='Estimated time' Value='3' />
					</Advanced_Settings>
					<TaskScript Name='TaskScript' Value='formInfo = task.Body
alert()
' />
					<Parameters >
						<Parameter Category='' Name='Title' Value='ACTION REQUIRED' />
						<Parameter Category='' Name='Body' Value='Please place a new source plate on location 5.' />
						<Parameter Category='' Name='Only show the first time' Value='' />
						<Parameter Category='' Name='Display dialog box' Value='1' />
						<Parameter Category='' Name='Pause process' Value='1' />
						<Parameter Category='' Name='Email' Value='0' />
						<Parameter Category='' Name='Twitter message' Value='0' />
						<Parameter Category='Scripting variable data entry' Name='User data entry into variable' Value='1' />
						<Parameter Category='Scripting variable data entry' Name='Variable name' Value='dummy' />
						<Parameter Category='Task Description' Name='Task number' Value='1' />
						<Parameter Category='Task Description' Name='Task description' Value='User Message' />
						<Parameter Category='Task Description' Name='Use default task description' Value='1' />
					</Parameters>
				</Task>
				<Task Name='BuiltIn::Place Plate' >
					<Devices >
						<Device Device_Name='Agilent Bravo - 1' Location_Name='5' />
					</Devices>
					<Enable_Backup >0</Enable_Backup>
					<Task_Disabled >0</Task_Disabled>
					<Task_Skipped >0</Task_Skipped>
					<Has_Breakpoint >0</Has_Breakpoint>
					<Advanced_Settings />
					<TaskScript Name='TaskScript' Value='plate.labware = sourceLabware
formInfo = &quot;&quot;
' />
					<Parameters >
						<Parameter Category='Task Description' Name='Task number' Value='2' />
						<Parameter Category='Task Description' Name='Task description' Value='Place Plate' />
						<Parameter Category='Task Description' Name='Use default task description' Value='1' />
						<Parameter Category='' Name='Device to use' Value='Agilent Bravo - 1' />
						<Parameter Category='' Name='Location to use' Value='5' />
					</Parameters>
				</Task>
				<Task Name='BuiltIn::User Message' >
					<Enable_Backup >0</Enable_Backup>
					<Task_Disabled >0</Task_Disabled>
					<Task_Skipped >0</Task_Skipped>
					<Has_Breakpoint >0</Has_Breakpoint>
					<Advanced_Settings >
						<Setting Name='Estimated time' Value='2' />
					</Advanced_Settings>
					<TaskScript Name='TaskScript' Value='formInfo = task.Body
alert()
' />
					<Parameters >
						<Parameter Category='' Name='Title' Value='ACTION REQUIRED' />
						<Parameter Category='' Name='Body' Value='Pause the protocol using the &apos;Pause &amp; Diagnose&apos; button below and ensure that the tip state editor is updated and there are enough tips present for all of the source tubes!' />
						<Parameter Category='' Name='Only show the first time' Value='' />
						<Parameter Category='' Name='Display dialog box' Value='1' />
						<Parameter Category='' Name='Pause process' Value='1' />
						<Parameter Category='' Name='Email' Value='0' />
						<Parameter Category='' Name='Twitter message' Value='0' />
						<Parameter Category='Scripting variable data entry' Name='User data entry into variable' Value='1' />
						<Parameter Category='Scripting variable data entry' Name='Variable name' Value='dummy' />
						<Parameter Category='Task Description' Name='Task number' Value='3' />
						<Parameter Category='Task Description' Name='Task description' Value='User Message' />
						<Parameter Category='Task Description' Name='Use default task description' Value='1' />
					</Parameters>
				</Task>
				<Task Name='Bravo::SubProcess' >
					<Enable_Backup >0</Enable_Backup>
					<Task_Disabled >0</Task_Disabled>
					<Task_Skipped >0</Task_Skipped>
					<Has_Breakpoint >0</Has_Breakpoint>
					<Advanced_Settings />
					<TaskScript Name='TaskScript' Value='' />
					<Parameters >
						<Parameter Category='' Name='Sub-process name' Value='pool' />
						<Parameter Category='Static labware configuration' Name='Display confirmation' Value='Don&apos;t display' />
						<Parameter Category='Static labware configuration' Name='1' Value='&lt;use default&gt;' />
						<Parameter Category='Static labware configuration' Name='2' Value='&lt;use default&gt;' />
						<Parameter Category='Static labware configuration' Name='3' Value='&lt;use default&gt;' />
						<Parameter Category='Static labware configuration' Name='4' Value='&lt;use default&gt;' />
						<Parameter Category='Static labware configuration' Name='5' Value='&lt;use default&gt;' />
						<Parameter Category='Static labware configuration' Name='6' Value='&lt;use default&gt;' />
						<Parameter Category='Static labware configuration' Name='7' Value='&lt;use default&gt;' />
						<Parameter Category='Static labware configuration' Name='8' Value='&lt;use default&gt;' />
						<Parameter Category='Static labware configuration' Name='9' Value='&lt;use default&gt;' />
					</Parameters>
					<Parameters >
						<Parameter Centrifuge='0' Name='SubProcess_Name' Pipettor='1' Value='pool' />
					</Parameters>
				</Task>
				<Plate_Parameters >
					<Parameter Name='Plate name' Value='source' />
					<Parameter Name='Plate type' Value='24-well 1.5 mL Eppendorf tube as a 24' />
					<Parameter Name='Simultaneous plates' Value='1' />
					<Parameter Name='Plates have lids' Value='0' />
					<Parameter Name='Plates enter the system sealed' Value='0' />
					<Parameter Name='Use single instance of plate' Value='0' />
					<Parameter Name='Automatically update labware' Value='0' />
					<Parameter Name='Enable timed release' Value='0' />
					<Parameter Name='Release time' Value='30' />
					<Parameter Name='Auto managed counterweight' Value='0' />
					<Parameter Name='Barcode filename' Value='No Selection' />
					<Parameter Name='Has header' Value='' />
					<Parameter Name='Barcode or header South' Value='No Selection' />
					<Parameter Name='Barcode or header West' Value='No Selection' />
					<Parameter Name='Barcode or header North' Value='No Selection' />
					<Parameter Name='Barcode or header East' Value='No Selection' />
				</Plate_Parameters>
				<Quarantine_After_Process >0</Quarantine_After_Process>
			</Process>
			<Process >
				<Minimized >0</Minimized>
				<Task Name='BuiltIn::User Message' >
					<Enable_Backup >0</Enable_Backup>
					<Task_Disabled >0</Task_Disabled>
					<Task_Skipped >0</Task_Skipped>
					<Has_Breakpoint >0</Has_Breakpoint>
					<Advanced_Settings >
						<Setting Name='Estimated time' Value='5.0' />
					</Advanced_Settings>
					<TaskScript Name='TaskScript' Value='formInfo = task.Body
alert()
' />
					<Parameters >
						<Parameter Category='' Name='Title' Value='ERROR' />
						<Parameter Category='' Name='Body' Value='Volume error, please check and restart the protocol. ' />
						<Parameter Category='' Name='Only show the first time' Value='' />
						<Parameter Category='' Name='Display dialog box' Value='1' />
						<Parameter Category='' Name='Pause process' Value='1' />
						<Parameter Category='' Name='Email' Value='0' />
						<Parameter Category='' Name='Twitter message' Value='0' />
						<Parameter Category='Scripting variable data entry' Name='User data entry into variable' Value='1' />
						<Parameter Category='Scripting variable data entry' Name='Variable name' Value='dummy' />
						<Parameter Category='Task Description' Name='Task number' Value='1' />
						<Parameter Category='Task Description' Name='Task description' Value='User Message' />
						<Parameter Category='Task Description' Name='Use default task description' Value='1' />
					</Parameters>
				</Task>
				<Plate_Parameters >
					<Parameter Name='Plate name' Value='abort' />
					<Parameter Name='Plate type' Value='' />
					<Parameter Name='Simultaneous plates' Value='1' />
					<Parameter Name='Plates have lids' Value='0' />
					<Parameter Name='Plates enter the system sealed' Value='0' />
					<Parameter Name='Use single instance of plate' Value='0' />
					<Parameter Name='Automatically update labware' Value='0' />
					<Parameter Name='Enable timed release' Value='0' />
					<Parameter Name='Release time' Value='30' />
					<Parameter Name='Auto managed counterweight' Value='0' />
					<Parameter Name='Barcode filename' Value='No Selection' />
					<Parameter Name='Has header' Value='' />
					<Parameter Name='Barcode or header South' Value='No Selection' />
					<Parameter Name='Barcode or header West' Value='No Selection' />
					<Parameter Name='Barcode or header North' Value='No Selection' />
					<Parameter Name='Barcode or header East' Value='No Selection' />
				</Plate_Parameters>
				<Quarantine_After_Process >0</Quarantine_After_Process>
			</Process>
			<Pipette_Process Name='pool' >
				<Minimized >0</Minimized>
				<Task Name='Bravo::secondary::Set Head Mode' Task_Type='512' >
					<Enable_Backup >0</Enable_Backup>
					<Task_Disabled >0</Task_Disabled>
					<Task_Skipped >0</Task_Skipped>
					<Has_Breakpoint >0</Has_Breakpoint>
					<Advanced_Settings >
						<Setting Name='Estimated time' Value='0' />
					</Advanced_Settings>
					<TaskScript Name='TaskScript' Value='' />
					<Parameters >
						<Parameter Category='' Name='Head mode' Value='&lt;?xml version=&apos;1.0&apos; encoding=&apos;ASCII&apos; ?&gt;
&lt;Velocity11 file=&apos;MetaData&apos; md5sum=&apos;f3c57de56bf5d361ee4249fe09d18f71&apos; version=&apos;1.0&apos; &gt;
	&lt;PipetteHeadMode Channels=&apos;0&apos; ColumnCount=&apos;1&apos; RowCount=&apos;1&apos; SubsetConfig=&apos;0&apos; SubsetType=&apos;4&apos; TipType=&apos;0&apos; /&gt;
&lt;/Velocity11&gt;' />
						<Parameter Category='Task Description' Name='Task number' Value='1' />
						<Parameter Category='Task Description' Name='Task description' Value='Set Head Mode (Bravo)' />
						<Parameter Category='Task Description' Name='Use default task description' Value='1' />
					</Parameters>
					<PipetteHead AssayMap='0' Disposable='1' HasTips='1' MaxRange='251' MinRange='-41' Name='96LT, 200 µL Series III' >
						<PipetteHeadMode Channels='0' ColumnCount='1' RowCount='1' SubsetConfig='0' SubsetType='4' TipType='0' />
					</PipetteHead>
				</Task>
				<Task Name='BuiltIn::Loop' >
					<Enable_Backup >0</Enable_Backup>
					<Task_Disabled >0</Task_Disabled>
					<Task_Skipped >0</Task_Skipped>
					<Has_Breakpoint >0</Has_Breakpoint>
					<Advanced_Settings />
					<TaskScript Name='TaskScript' Value='' />
					<Parameters >
						<Parameter Category='' Name='Number of times to loop' TaskParameterScript='=nPlates' Value='1' />
						<Parameter Category='' Name='Change tips every N times, N = ' Value='1' />
					</Parameters>
					<Variables >
						<Variable fIncrement='1' iFreqValue='0' strFrequency='Every time' strInitialValue='0' strVariableName='ind' />
					</Variables>
				</Task>
				<Task Name='BuiltIn::Loop' >
					<Enable_Backup >0</Enable_Backup>
					<Task_Disabled >0</Task_Disabled>
					<Task_Skipped >0</Task_Skipped>
					<Has_Breakpoint >0</Has_Breakpoint>
					<Advanced_Settings />
					<TaskScript Name='TaskScript' Value='' />
					<Parameters >
						<Parameter Category='' Name='Number of times to loop' TaskParameterScript='=myPlates[ind].items' Value='1' />
						<Parameter Category='' Name='Change tips every N times, N = ' Value='1' />
					</Parameters>
					<Variables >
						<Variable fIncrement='1' iFreqValue='0' strFrequency='Every time' strInitialValue='0' strVariableName='ind2' />
					</Variables>
				</Task>
				<Task Name='BuiltIn::Group Begin' >
					<Enable_Backup >0</Enable_Backup>
					<Task_Disabled >0</Task_Disabled>
					<Task_Skipped >0</Task_Skipped>
					<Has_Breakpoint >0</Has_Breakpoint>
					<Advanced_Settings />
					<TaskScript Name='TaskScript' Value='' />
					<Parameters >
						<Parameter Category='Task Description' Name='Task number' Value='4' />
						<Parameter Category='Task Description' Name='Task description' Value='Group Begin' />
						<Parameter Category='Task Description' Name='Use default task description' Value='1' />
					</Parameters>
				</Task>
				<Task Name='BuiltIn::JavaScript' >
					<Enable_Backup >0</Enable_Backup>
					<Task_Disabled >0</Task_Disabled>
					<Task_Skipped >0</Task_Skipped>
					<Has_Breakpoint >0</Has_Breakpoint>
					<Advanced_Settings >
						<Setting Name='Estimated time' Value='0' />
					</Advanced_Settings>
					<TaskScript Name='TaskScript' Value='vol = Number(myPlates[ind].vol[ind2])
sWellsel =  getWellselection(myPlates[ind].sWell[ind2] , 96)

// destination stuff
iDest++
tmpDest = iDest%destWells // always 0-47
destName = &quot;Destination_&quot; + (1 + Math.floor(iDest / destWells)) 

print(&quot;current source wellselection = &quot; + sWellsel)




   ' />
					<Parameters >
						<Parameter Category='Task Description' Name='Task number' Value='5' />
						<Parameter Category='Task Description' Name='Task description' Value='JavaScript' />
						<Parameter Category='Task Description' Name='Use default task description' Value='1' />
					</Parameters>
				</Task>
				<Task Name='Bravo::secondary::Tips On' Task_Type='16' >
					<Enable_Backup >0</Enable_Backup>
					<Task_Disabled >0</Task_Disabled>
					<Task_Skipped >0</Task_Skipped>
					<Has_Breakpoint >0</Has_Breakpoint>
					<Advanced_Settings >
						<Setting Name='Estimated time' Value='9' />
					</Advanced_Settings>
					<TaskScript Name='TaskScript' Value='' />
					<Parameters >
						<Parameter Category='' Name='Location, plate' Value='8' />
						<Parameter Category='' Name='Location, location' Value='&lt;auto-select&gt;' />
						<Parameter Category='Properties' Name='Allow automatic tracking of tip usage' Value='1' />
						<Parameter Category='Properties' Name='Well selection' Value='&lt;?xml version=&apos;1.0&apos; encoding=&apos;ASCII&apos; ?&gt;
&lt;Velocity11 file=&apos;MetaData&apos; md5sum=&apos;db2866548f0769614337a677432b12e3&apos; version=&apos;1.0&apos; &gt;
	&lt;WellSelection CanBe16QuadrantPattern=&apos;0&apos; CanBeLinked=&apos;0&apos; CanBeQuadrantPattern=&apos;0&apos; IsLinked=&apos;0&apos; IsQuadrantPattern=&apos;0&apos; OnlyOneSelection=&apos;0&apos; OverwriteHeadMode=&apos;0&apos; QuadrantPattern=&apos;0&apos; StartingQuadrant=&apos;1&apos; &gt;
		&lt;PipetteHeadMode Channels=&apos;0&apos; ColumnCount=&apos;1&apos; RowCount=&apos;1&apos; SubsetConfig=&apos;0&apos; SubsetType=&apos;4&apos; TipType=&apos;0&apos; /&gt;
		&lt;Wells &gt;
			&lt;Well Column=&apos;6&apos; Row=&apos;7&apos; /&gt;
		&lt;/Wells&gt;
	&lt;/WellSelection&gt;
&lt;/Velocity11&gt;' />
						<Parameter Category='Task Description' Name='Task number' Value='6' />
						<Parameter Category='Task Description' Name='Task description' Value='Tips On (Bravo)' />
						<Parameter Category='Task Description' Name='Use default task description' Value='1' />
					</Parameters>
					<PipetteHead AssayMap='0' Disposable='1' HasTips='1' MaxRange='251' MinRange='-41' Name='96LT, 200 µL Series III' >
						<PipetteHeadMode Channels='0' ColumnCount='1' RowCount='1' SubsetConfig='0' SubsetType='4' TipType='0' />
					</PipetteHead>
				</Task>
				<Task Name='Bravo::secondary::Aspirate' Task_Type='1' >
					<Enable_Backup >0</Enable_Backup>
					<Task_Disabled >0</Task_Disabled>
					<Task_Skipped >0</Task_Skipped>
					<Has_Breakpoint >0</Has_Breakpoint>
					<Advanced_Settings >
						<Setting Name='Estimated time' Value='17' />
					</Advanced_Settings>
					<TaskScript Name='TaskScript' Value='task.Wellselection = [ sWellsel ]

' />
					<Parameters >
						<Parameter Category='' Name='Location, plate' Value='source' />
						<Parameter Category='' Name='Location, location' Value='&lt;auto-select&gt;' />
						<Parameter Category='Volume' Name='Volume' TaskParameterScript='=poolVol' Value='poolVol' />
						<Parameter Category='Volume' Name='Pre-aspirate volume' Value='10' />
						<Parameter Category='Volume' Name='Post-aspirate volume' Value='10' />
						<Parameter Category='Properties' Name='Liquid class' Value='MeOH:DCM dispense' />
						<Parameter Category='Properties' Name='Distance from well bottom' Value='2' />
						<Parameter Category='Properties' Name='Dynamic tip extension' Value='0' />
						<Parameter Category='Tip Touch' Name='Perform tip touch' Value='0' />
						<Parameter Category='Tip Touch' Name='Which sides to use for tip touch' Value='None' />
						<Parameter Category='Tip Touch' Name='Tip touch retract distance' Value='0' />
						<Parameter Category='Tip Touch' Name='Tip touch horizontal offset' Value='0' />
						<Parameter Category='Properties' Name='Well selection' Value='&lt;?xml version=&apos;1.0&apos; encoding=&apos;ASCII&apos; ?&gt;
&lt;Velocity11 file=&apos;MetaData&apos; md5sum=&apos;c11e6d6b068be97a72100ad9b9de9bfe&apos; version=&apos;1.0&apos; &gt;
	&lt;WellSelection CanBe16QuadrantPattern=&apos;0&apos; CanBeLinked=&apos;0&apos; CanBeQuadrantPattern=&apos;0&apos; IsLinked=&apos;0&apos; IsQuadrantPattern=&apos;0&apos; OnlyOneSelection=&apos;0&apos; OverwriteHeadMode=&apos;0&apos; QuadrantPattern=&apos;0&apos; StartingQuadrant=&apos;1&apos; &gt;
		&lt;PipetteHeadMode Channels=&apos;0&apos; ColumnCount=&apos;1&apos; RowCount=&apos;1&apos; SubsetConfig=&apos;0&apos; SubsetType=&apos;4&apos; TipType=&apos;0&apos; /&gt;
		&lt;Wells &gt;
			&lt;Well Column=&apos;0&apos; Row=&apos;0&apos; /&gt;
		&lt;/Wells&gt;
	&lt;/WellSelection&gt;
&lt;/Velocity11&gt;' />
						<Parameter Category='Properties' Name='Pipette technique' Value='' />
						<Parameter Category='Task Description' Name='Task number' Value='7' />
						<Parameter Category='Task Description' Name='Task description' Value='Aspirate (Bravo)' />
						<Parameter Category='Task Description' Name='Use default task description' Value='1' />
					</Parameters>
					<PipetteHead AssayMap='0' Disposable='1' HasTips='1' MaxRange='251' MinRange='-41' Name='96LT, 200 µL Series III' >
						<PipetteHeadMode Channels='0' ColumnCount='1' RowCount='1' SubsetConfig='0' SubsetType='4' TipType='0' />
					</PipetteHead>
				</Task>
				<Task Name='Bravo::secondary::Dispense' Task_Type='2' >
					<Enable_Backup >0</Enable_Backup>
					<Task_Disabled >0</Task_Disabled>
					<Task_Skipped >0</Task_Skipped>
					<Has_Breakpoint >0</Has_Breakpoint>
					<Advanced_Settings >
						<Setting Name='Estimated time' Value='9' />
					</Advanced_Settings>
					<TaskScript Name='TaskScript' Value='
' />
					<Parameters >
						<Parameter Category='' Name='Location, plate' Value='6' />
						<Parameter Category='' Name='Location, location' Value='&lt;auto-select&gt;' />
						<Parameter Category='Volume' Name='Empty tips' Value='1' />
						<Parameter Category='Volume' Name='Volume' Value='10' />
						<Parameter Category='Volume' Name='Blowout volume' Value='0' />
						<Parameter Category='Properties' Name='Liquid class' Value='' />
						<Parameter Category='Properties' Name='Distance from well bottom' Value='10' />
						<Parameter Category='Properties' Name='Dynamic tip retraction' Value='0' />
						<Parameter Category='Tip Touch' Name='Perform tip touch' Value='1' />
						<Parameter Category='Tip Touch' Name='Which sides to use for tip touch' Value='West/East' />
						<Parameter Category='Tip Touch' Name='Tip touch retract distance' Value='0' />
						<Parameter Category='Tip Touch' Name='Tip touch horizontal offset' Value='0' />
						<Parameter Category='Properties' Name='Well selection' Value='&lt;?xml version=&apos;1.0&apos; encoding=&apos;ASCII&apos; ?&gt;
&lt;Velocity11 file=&apos;MetaData&apos; md5sum=&apos;c11e6d6b068be97a72100ad9b9de9bfe&apos; version=&apos;1.0&apos; &gt;
	&lt;WellSelection CanBe16QuadrantPattern=&apos;0&apos; CanBeLinked=&apos;0&apos; CanBeQuadrantPattern=&apos;0&apos; IsLinked=&apos;0&apos; IsQuadrantPattern=&apos;0&apos; OnlyOneSelection=&apos;0&apos; OverwriteHeadMode=&apos;0&apos; QuadrantPattern=&apos;0&apos; StartingQuadrant=&apos;1&apos; &gt;
		&lt;PipetteHeadMode Channels=&apos;0&apos; ColumnCount=&apos;1&apos; RowCount=&apos;1&apos; SubsetConfig=&apos;0&apos; SubsetType=&apos;4&apos; TipType=&apos;0&apos; /&gt;
		&lt;Wells &gt;
			&lt;Well Column=&apos;0&apos; Row=&apos;0&apos; /&gt;
		&lt;/Wells&gt;
	&lt;/WellSelection&gt;
&lt;/Velocity11&gt;' />
						<Parameter Category='Properties' Name='Pipette technique' Value='' />
						<Parameter Category='Task Description' Name='Task number' Value='8' />
						<Parameter Category='Task Description' Name='Task description' Value='Dispense (Bravo)' />
						<Parameter Category='Task Description' Name='Use default task description' Value='0' />
					</Parameters>
					<PipetteHead AssayMap='0' Disposable='1' HasTips='1' MaxRange='251' MinRange='-41' Name='96LT, 200 µL Series III' >
						<PipetteHeadMode Channels='0' ColumnCount='1' RowCount='1' SubsetConfig='0' SubsetType='4' TipType='0' />
					</PipetteHead>
				</Task>
				<Task Name='Bravo::secondary::Tips Off' Task_Type='32' >
					<Enable_Backup >0</Enable_Backup>
					<Task_Disabled >0</Task_Disabled>
					<Task_Skipped >0</Task_Skipped>
					<Has_Breakpoint >0</Has_Breakpoint>
					<Advanced_Settings >
						<Setting Name='Estimated time' Value='7' />
					</Advanced_Settings>
					<TaskScript Name='TaskScript' Value='' />
					<Parameters >
						<Parameter Category='' Name='Location, plate' Value='9' />
						<Parameter Category='' Name='Location, location' Value='&lt;auto-select&gt;' />
						<Parameter Category='Properties' Name='Allow automatic tracking of tip usage' Value='1' />
						<Parameter Category='Properties' Name='Mark tips as used' Value='1' />
						<Parameter Category='Properties' Name='Well selection' Value='&lt;?xml version=&apos;1.0&apos; encoding=&apos;ASCII&apos; ?&gt;
&lt;Velocity11 file=&apos;MetaData&apos; md5sum=&apos;dd195f6880c37e197daffd7ed9cd0fff&apos; version=&apos;1.0&apos; &gt;
	&lt;WellSelection CanBe16QuadrantPattern=&apos;0&apos; CanBeLinked=&apos;0&apos; CanBeQuadrantPattern=&apos;0&apos; IsLinked=&apos;0&apos; IsQuadrantPattern=&apos;0&apos; OnlyOneSelection=&apos;0&apos; OverwriteHeadMode=&apos;0&apos; QuadrantPattern=&apos;0&apos; StartingQuadrant=&apos;1&apos; &gt;
		&lt;PipetteHeadMode Channels=&apos;0&apos; ColumnCount=&apos;1&apos; RowCount=&apos;1&apos; SubsetConfig=&apos;0&apos; SubsetType=&apos;4&apos; TipType=&apos;0&apos; /&gt;
		&lt;Wells &gt;
			&lt;Well Column=&apos;3&apos; Row=&apos;7&apos; /&gt;
		&lt;/Wells&gt;
	&lt;/WellSelection&gt;
&lt;/Velocity11&gt;' />
						<Parameter Category='Task Description' Name='Task number' Value='9' />
						<Parameter Category='Task Description' Name='Task description' Value='Tips Off (Bravo)' />
						<Parameter Category='Task Description' Name='Use default task description' Value='1' />
					</Parameters>
					<PipetteHead AssayMap='0' Disposable='1' HasTips='1' MaxRange='251' MinRange='-41' Name='96LT, 200 µL Series III' >
						<PipetteHeadMode Channels='0' ColumnCount='1' RowCount='1' SubsetConfig='0' SubsetType='4' TipType='0' />
					</PipetteHead>
				</Task>
				<Task Name='BuiltIn::Group End' >
					<Enable_Backup >0</Enable_Backup>
					<Task_Disabled >0</Task_Disabled>
					<Task_Skipped >0</Task_Skipped>
					<Has_Breakpoint >0</Has_Breakpoint>
					<Advanced_Settings />
					<TaskScript Name='TaskScript' Value='' />
					<Parameters >
						<Parameter Category='Task Description' Name='Task number' Value='10' />
						<Parameter Category='Task Description' Name='Task description' Value='Group End' />
						<Parameter Category='Task Description' Name='Use default task description' Value='1' />
					</Parameters>
				</Task>
				<Task Name='BuiltIn::Loop End' >
					<Enable_Backup >0</Enable_Backup>
					<Task_Disabled >0</Task_Disabled>
					<Task_Skipped >0</Task_Skipped>
					<Has_Breakpoint >0</Has_Breakpoint>
					<Advanced_Settings />
					<TaskScript Name='TaskScript' Value='' />
				</Task>
				<Task Name='BuiltIn::Change Instance' >
					<Enable_Backup >0</Enable_Backup>
					<Task_Disabled >0</Task_Disabled>
					<Task_Skipped >0</Task_Skipped>
					<Has_Breakpoint >0</Has_Breakpoint>
					<Advanced_Settings />
					<TaskScript Name='TaskScript' Value='' />
					<Parameters >
						<Parameter Category='' Name='Plate to change' Value='source' />
						<Parameter Category='' Name='Spawn control' Value='Spawn new plates when task runs ' />
						<Parameter Category='' Name='Spawn parameter' Value='' />
						<Parameter Category='Task Description' Name='Task number' Value='12' />
						<Parameter Category='Task Description' Name='Task description' Value='Change Instance' />
						<Parameter Category='Task Description' Name='Use default task description' Value='1' />
					</Parameters>
				</Task>
				<Task Name='BuiltIn::Loop End' >
					<Enable_Backup >0</Enable_Backup>
					<Task_Disabled >0</Task_Disabled>
					<Task_Skipped >0</Task_Skipped>
					<Has_Breakpoint >0</Has_Breakpoint>
					<Advanced_Settings />
					<TaskScript Name='TaskScript' Value='' />
				</Task>
				<Devices >
					<Device Device_Name='Agilent Bravo - 1' Location_Name='Default Location' />
				</Devices>
				<Parameters >
					<Parameter Name='Display confirmation' Value='Don&apos;t display' />
					<Parameter Name='1' Value='&lt;use default&gt;' />
					<Parameter Name='2' Value='&lt;use default&gt;' />
					<Parameter Name='3' Value='&lt;use default&gt;' />
					<Parameter Name='4' Value='&lt;use default&gt;' />
					<Parameter Name='5' Value='&lt;use default&gt;' />
					<Parameter Name='6' Value='&lt;use default&gt;' />
					<Parameter Name='7' Value='&lt;use default&gt;' />
					<Parameter Name='8' Value='&lt;use default&gt;' />
					<Parameter Name='9' Value='&lt;use default&gt;' />
				</Parameters>
				<Dependencies />
			</Pipette_Process>
		</Main_Processes>
	</Processes>
</Velocity11>