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