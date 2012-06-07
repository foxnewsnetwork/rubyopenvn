/**
* Flotile Bridge Class
*/
 // Bridging the gap between haxe and standard javascript
var FFOpenVN = character.VisualNovel;
var FFOpenVNEditor = character.VisualNovelEditor;

// processing
function ProcessRawVisualNovelData(rawdata) { 
	// Step 1: Sort the scenes by number
	var scenes = rawdata['scenes'];
	scenes.sort( function(a,b) { 
		return a["number"] - b['number'];
	} ); // scenes.sort
	
	// Step 2: Use a hash to store scene data
	var scene_data = {};
	for( var k = 0; k < rawdata['scene_data'].length; k++ ) { 
		if ( scene_data[rawdata['scene_data'][k]['scene_id']] == undefined ) { 
			scene_data[rawdata['scene_data'][k]['scene_id']] = [];
		} // if
		scene_data[rawdata['scene_data'][k]['scene_id']].push( rawdata['scene_data'][k] );
	} // for
	
  // Step 2.5: Getting Elements
  // NOT DONE YET!
  
	// Step 3: Putting it together
  var output = [];
  for( var k = 0; k < scenes.length; k++) { 
    output.push({
      "background" : { "image" : backgrounds[scenes[k]["id"]] },
      "foreground" : { 
        "images" : foregrounds[scenes[k]["id"]] ,
        "positions" : positions[scenes[k]["id"]] ,
        "sizes" : sizes[scenes[k]["id"]] ,
      },
      "text" : { 
        "content" : contents[scenes[k]["id"]]
      }
    }); // end output.push
  } // end for
} // ProcessRawVisualNovelData

// comparer needs to take 2 parameters (elements of vector
// returns 1 when the param1 is bigger than param2, -1 when smaller, and 0 when equal
function QuickSort(vector, comparer) {
	// Step -1 : Bad input
	if( vector == undefined || vector.length == 0 ) { 
		return;
	} // if

	// Step 0: Terminating condition
	if( vector.length == 1 ) { 
		return vector;
	} // end if
	
	// Step 1.5: Just in-case
	if( vector.length == 2 ) { 
		if( compareer( vector[0], vector[1] ) < 0 )
			return vector;
		else
			return [vector[1], vector[2]];
	} // if
	 
	// Step 1: Pick a pivot
	var pivot = Math.floor(vector.length / 2)
	
	// Step 2: create two stacks
	var smaller = [];
	var bigger = vector[pivot]
	
	// Step 3: Push to the appropriate one
	for( var k = 0; k < vector.length; k++ ) { 
		if ( comparer( vector[k], vector[pivot] ) < 0 )
			smaller.push( vector[k] )
		else
			bigger.push( vector[k] )
	} // for
	
	// Step 4: Recursion & Recomposition
	return QuickSort(smaller, comparer).concat(QuickSort(bigger, comparer));
} // QuickSort
// Sorts a vector into an array tree
function TreeSort(vector) { 
	// Step 1: Finding the head
	var head;
	var temphash = {};
	for ( var k = 0; k < vector.length; k++ ) { 
		if ( vector[k].parent == undefined ) { 
			head = vector[k];
		} // end if
		temphash[vector[k]._id] = vector[k];
	} // end for
	


	// Step 2: Traversing to put in order
	var ordered = [], count = 0;
	var node = head;
	for( var k = 0; k < vector.length; k++ ) {
		ordered.push( node );
		var children = node.children;
		if ( children == undefined ) { 
			break;
		} // end if
		node = temphash[children[0]];
	} // end while
	
	// Step 3: We should return in on average o(1.5n)
	return ordered;
} // end TreeSort
