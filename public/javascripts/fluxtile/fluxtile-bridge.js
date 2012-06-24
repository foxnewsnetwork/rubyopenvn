// Bridge Class for communication purposes



function ConstructHashFromArray( arr, key ) { 
  var hash_output = {};
  for( var k = 0; k < arr.length; k++ ) { 
    if( hash_output[arr[k][key]] == undefined )
      hash_output[arr[k][key]] = [];
    hash_output[arr[k][key]].push( arr[k]  );
  } // for k
  return hash_output;
}; // ConstructHashFromArray  

function GetVisualNovelLoadData( cb ) { 
	var req = $.ajax({
		url : "/stories/" + VisualNovelMetadata['story'] + "/chapters/" + VisualNovelMetadata['chapter'] + "/edit.json" ,
		type : "get"
	}); // req
	
	req.done( function(html) { 
		/**
    * Phase A : Hash Construction
    */
    // Step 1: Declaration
    var scenes = html['scenes'];
		var layers = html['layers'];
		var elements = html['elements'];
		var stockpile = html['stockpile'];
		
		// Step 2: Construction
		var hash_scenes = ConstructHashFromArray( scenes, "id" );
		var hash_layers = ConstructHashFromArray( layers, "scene_id" );
		var hash_elements = ConstructHashFromArray( elements, "id" );			
		
		/**
    * Phase B : Data Structuring
    */
    var loaddata = [];
    for( var k = 0; k < scenes.length; k++ ) { 
    	// Step 1: Declaration
    	var s = scenes[k];
    	var l = hash_layers[s.scene_id];
  		if ( l != undefined ) { 
  			// Step 2: Layer structuring
		  	for( var j = 0; j < l.length; j++ ) { 
		  		l[j]['images'] = hash_elements[l.element_id].picture;
		  	} // for j
		  	// Step 3: Scene structuring
		  	s['layers'] = l;
  		} // if l
  		else
				s['layers'] = [];
  
    	// Step 4: Adding to output
    	loaddata.push( s );
    } // for k
    
		/**
    * Phase C : VN Loading
    */      
    
		cb( loaddata, stockpile );
	} ); // req.done
} // GetVisualNovelLoadData

function FluxTileBridge_Commit(scenes) {
	alert(JSON.stringify( scenes ) );
	var output_data = { 
		scenes : scenes ,
		batch : true ,
		authenticity_token : VisualNovelMetadata['authenticity_token']
	}; // data
	
	var req = $.ajax({
	  url : "/stories/" + VisualNovelMetadata['story'] + "/chapters/" + VisualNovelMetadata['chapter'] ,
		type : "PUT" ,
    data : output_data
	}).done(function(html){ return; }); // ajax
}; // FluxTileBridge_Commit

function FluxTileBridge_Fork(cb) { 
	var output_data = { 
		authenticity_token : VisualNovelMetadata['authenticity_token']
	}; // output_data
	var req = $.ajax({
		url : "/stories/" + VisualNovelMetadata['story'] + "/chapters/" + VisualNovelMetadata['chapter'] + "/scenes" ,
		type : "POST" ,
		data : output_data
	}).done(function(html){ 
		var data = JSON.parse(html);
		cb(data['id']);
	}); // ajax
}; // FluxTileBridge_Fork
function FluxTileBridge_Load(vn) { 
	GetVisualNovelLoadData( function(loaddata, stockdata) { 
		
		vn.Load(loaddata);
		vn.SetupStockpile(stockdata);
		vn.SetupPermission( { user_id : VisualNovelMetadata['user_id'], level : 6 } );
		$("#now-loading").hide( 10, function() { 
			vn.Start();
		} ); // hide
	} ); // GetVisualNovelLoadData
}; // FluxTileBridge_Load
function FluxTileBridege_Delete( data ) { 
	alert( "Write me! fluxtile-bridge.js Line 106" );
}; // FluxTileBridge_Delet
