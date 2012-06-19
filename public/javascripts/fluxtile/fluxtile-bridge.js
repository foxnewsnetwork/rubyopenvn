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
  
	function GetJunk() { 
		var req = $.ajax({
		  url : location.pathname + ".json" ,
		  type : "get"
		}); // req
		req.done( function(html) { 
      /**
      * Phase A : Hash Construction
      */
      // Step 1: Declaration
      var scenes = html['scenes'];
			var scenedata = html['scene_data'];
			var elements = html['elements'];
			var element_relationships = html['element_relationships'];
			var stockpile = html['stockpile'];
			
			// Step 2: Construction
			var hash_scene = ConstructHashFromArray( scenes, "id" );
			var hash_scenedata = ConstructHashFromArray( scenedata, "scene_id" );
			var hash_er_sdid = ConstructHashFromArray( element_relationships, "scene_data_id" );
			var hash_elements = ConstructHashFromArray( elements, "id" );
			
      /**
      * Phase B : Data Structuring
      */
      var output = [];
      for( var k = 0; k < scenes.length; k++ ) { 
        var datum = { }; 
        // Step 1: Declaration
        var s = scenes[k];
        var sd = hash_scenedata[s.scene_id];
        var er = [];
        for( var j = 0; j < sd.length; j++ ) { 
          er = $.merge( er, hash_er_sdid[sd[j].scene_data_id] );
        } // for j
        
        // Step 2: Layer structuring
        var layers = [{ 
          image : hash_elements[ sd.element_id ].picture ,
          width : sd.width ,
          height : sd.height ,
          x : sd.left ,
          y : sd.top
        }]; // layers
        for( var j = 0; j < er.length; j++ ) { 
          var layer = { 
            image : hash_elements[ er.parent_id ].picture ,
            width : er.width ,
            height : er.height ,
            x : er.left ,
            y : er.top
          }; // layer
          layers.push( layer );
        } // for j
        // Step 3: Relational data structuring
        datum["layers"] = layers;
        datum["text"] = sd.dialogue;
        datum["id"] = s.id;
        datum["parent_id"] = s.parent_id;
        datum["children_id"] = s.children_id;
        datum["fork_text"] = s.fork_text;
        datum["fork_image"] = null;
        datum["fork_number"] = s.fork_number;
        
        // Step 4: Tagging it on
        output.push(datum);
      } // for k
      
      /**
      * Phase C : VN Loading
      */
      // TODO: Load the VN
      $("#debug").html( JSON.stringify( output ) );
		} ); // req.done
	} // GetJunk

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
	
	function PutScene( scenedata ) { 
	  var action = "/stories/" + VisualNovelMetadata['story'] + "/chapters/" + VisualNovelMetadata['chapter'] + "/scenes/" + scenedata['id'];
	  var req = $.ajax( { 
	    url : action ,
	    type : "PUT" ,
	    data : $.merge( { batch : scenedata }, VisualNovelMetadata );
	  } ); // ajax
	  
	  req.done( function( html ) { 
	  
	  } ); // done
	} // PutScene
	GetJunk();
	$("#createscene").click(function(){ PostScene(); } );
} ); // ready
