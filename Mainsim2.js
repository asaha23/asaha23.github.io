<!DOCTYPE html>
<html>
<head>
<title> Modelling Matter- Chapter 1 </title>
<script src="matter.js" type="text/javascript"></script>
<script src="timerjs.js" type="text/javascript"></script>
<script src="Watermoleculeimage.js" type="text/javascript"></script>


<script src="Graphplot.js" type="text/javascript"></script>
<canvas id="background" style="width: 100%; height: 100%;"></canvas>
<script>
var c = document.getElementById('background');
var ctx = c.getContext('2d');
ctx.fillStyle = '#D8D8D8';
ctx.fillRect(0,0,c.width,c.height);
ctx.position = "absolute";

</script>
</head>
<div>
<style>
.button {
    background-color: #4CAF50;
    border: 10px outset yellowgreen;
    color: white;
    padding: 15px 32px;
    text-align: center;
    text-decoration: none;
    display: inline-block;
    font-size: 16px;
    margin: 4px 2px;
    cursor: pointer;
	position:absolute;
	left:100px;
	top: 30px;
}
</style>
<button width:600;height:500" onclick="myFunction()" class ="button" style="position:absolute;left:70px;top:100px;"><b>PAUSE</b></button>
</div>
<div>
<button onclick="myFunctionS()" class ="button" style="position:absolute;left:70px;top:170px;"><b>START<b/></button>
</div>
<div>
<button onclick="myFunctionR()" class ="button" style="position:absolute;left:70px;top:240px;"><b>RESET</b></button>
</div>
<div style="position:absolute;left:15px;top:360px;">No. of molecules to be added :</div>
<div>
<input id="moleculenumber" type="range" min="1" max="9" step="1" onchange="showValue(this.value)" style="position:absolute;left:70px;top:330px;"/>
<div id="range" style="position:absolute;left:70px;top:320px;">0</div>
<div style="position:absolute;left:60px;top:510px;">Container volume</div>
</div>
<div>
<input id="volumeslider" type="range" oninput="showValue2(this.value)" style="position:absolute;left:70px;top:480px;"/>
<div id="range2"style="position:absolute;left:70px;top:490px;">0</div>
</div>
<button onclick="myFunctionN()" class ="button" style="position:absolute;left:70px;top:380px;"><b>Add </b></button>
<div>
<input id="heatslider" type="range" min="-5" max="5" step="1" onchange="showValue3(this.value)" style="position:absolute;left:70px;top:530px;"/>
<div id="heatsliderval" style="position:absolute;left:70px;top:550px;">0</div>
<div style="position:absolute;left:60px;top:570px;"> Heat </div>
</div>
<canvas id="world"></canvas>
<script type="text/javascript">
      var main = document.getElementById("world");
      var render = main.getContext("2d");
      main.style.left = "280px";
      main.style.top = "10px";
      main.style.position = "absolute";
</script>

<style>
  .bordered {
    width: 170px;
    height: 50px;
    padding: 20px;
    border: 10px outset yellowgreen;
	 }
</style>  
<div id="chartContainer" style="position:absolute;left:950px;top:100px;width:300px;height:300px">
 
 </div>
 <script src="canvasjs.min.js" type="text/javascript"></script>
<div id="timer" class="bordered" style="position:absolute;left:1000px;top:450px;"><b><font color="Blue">0:0:0</font></b>
<div class="bordered" id="timer" style="position:absolute;left:1000px;top:400px;"><b>0:0:0</b></div>
</div>
<div style="position:absolute;left:1000px;top:570px;">Temperature : 25 Degrees C </div>
<script src = "CompoundBody3.js"> </script>
<div id ="schema" style="position:absolute;left:1000px;top:590px;">database </div>
<div id ="testdata" style="position:absolute;left:1000px;top:620px;">testdata </div>
<script>
    var db = null;
	
	function openNotesDatabase(){
	db = openDatabase('chemdbnew','1.0','html sqlite example',200000);
	//console.log(db);
	}
	
	
	function createNoteTable(){
            db.transaction(function(tx){tx.executeSql("create table compoundsnew (name TEXT, freezingPointCelsius REAL, boilingPointCelsius REAL)", [], function(result){ alert('Criando table WebKitStickyNotes: '+result)})});
        }
		
	function deleteNoteTable(){
            db.transaction(function(tx){tx.executeSql("drop table compoundsnew", [], function(result){ alert('Criando table WebKitStickyNotes: '+result)})});
        }
		
	function createNote(name,freezingPointCelsius,boilingPointCelsius){
            //rightnow=new Date().getTime();
            db.transaction(function(tx){
                tx.executeSql('insert into compoundsnew values(?,?,?) ', [name,freezingPointCelsius,boilingPointCelsius]);
            });
        }
		
	function showSchema(){
            db.transaction(function(tx){
                tx.executeSql("SELECT * FROM compoundsnew where name='water'", [], function(tx, result){
                    var schemanode=document.getElementById('schema');
                    schemanode.innerHTML="";

                    for (var i = 0; i < result.rows.length; i++){
                        var row = result.rows.item(i);
                        var notediv = document.createElement('div');
                        notediv.innerHTML='type:'+row['type']+', name: '+row['name']+', boilingPointCelsius:'+row['boilingPointCelsius']+', freezingPointCelsius: '+row['freezingPointCelsius'];
                        schemanode.appendChild(notediv);    
					
                    }
                }, function(tx, error){
                    alert('This is an error message - '+error.message);
                    return;
                });
            });
        }
		
		
		
	
	openNotesDatabase();
	createNoteTable();
	createNote('water',0,100);
	console.log(db);
	showSchema();
	deleteNoteTable();
	//console.log(notediv.innerHTML);
	//showSchema();
</script>
</body>
</html>