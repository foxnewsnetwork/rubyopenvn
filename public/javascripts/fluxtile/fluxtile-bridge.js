// Bridge Class for communication purposes



$(document).ready( function() { 
  
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
  		url : VisualNovelPathJson ,
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
      	
      	// Step 2: Layer structuring
      	for( var j = 0; j < l.length; j++ ) { 
      		l[j]['images'] = hash_elements[l.element_id].picture;
      	} // for j
      	
      	// Step 3: Scene structuring
      	s['layers'] = l;
      	
      	// Step 4: Adding to output
      	loaddata.push( s );
      } // for k
			/**
      * Phase C : VN Loading
      */      
			cb( loaddata, stockpile );
  	} ); // req.done
  } // GetVisualNovelLoadData


	function PostScene( scene ) {
		var action = "/stories/" + VisualNovelMetadata['story'] + "/chapters/" + VisualNovelMetadata['chapter'] + "/scenes";
		var req = $.ajax({
			url : action ,
			type : "POST" ,
			data : $.merge( VisualNovelMetadata, scene )
		}); // ajax
	
		req.done( function(html) { 
			var txt = "";
			for( var k in html) { 
				txt += k + " => ";
				for( var j in html[k] ) { 
				  txt += html[k][j];
				} // for j
			} // for k
		} ); // done
	} // PostScene
	
	function PutScene( scenes ) { 
	  var action = "/stories/" + VisualNovelMetadata['story'] + "/chapters/" + VisualNovelMetadata['chapter'] + "/scenes/" + scenedata['id'];
	  var req = $.ajax( { 
	    url : action ,
	    type : "PUT" ,
	    data : $.merge( { scenes : scenes, batch : true }, VisualNovelMetadata );
	  } ); // ajax
	  
	  req.done( function( html ) { 
	  
	  } ); // done
	} // PutScene

	$("#createscene").click(function(){ PostScene(); } );
} ); // ready
