var db = null;
	function openNotesDatabase(){
	db = openDatabase("chemdb","1.0","html sqlite example",200000);
	//console.log(db);
	}
	function showSchema(){
            db.transaction(function(tx){
                tx.executeSql("SELECT * FROM compounds", [], function(tx, result){
                    var schemanode=document.getElementById('schema');
                    schemanode.innerHTML="";

                    for (var i = 0; i < result.rows.length; i++){
                        var row = result.rows.item(i);
                        var notediv = document.createElement('div');
                        notediv.innerHTML='type:'+row['type']+', name: '+row['name']+', tbl_name:'+row['tbl_name']+', rootpage: '+row['rootpage']+', sql: '+row['sql'];
                        schemanode.appendChild(notediv);                        
                    }
                }, function(tx, error){
                    alert('Falha ao buscar dados no banco - '+error.message);
                    return;
                });
            });
		console.log(notediv.innerHTML);
        }