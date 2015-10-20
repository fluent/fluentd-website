var Contact = function () {

    return {
        
        //Map
        initMap: function () {
			var map;
			$(document).ready(function(){
			  map = new GMaps({
				div: '#map',
				lat: 40.748866,
				lng: -73.988366
			  });
			   var marker = map.addMarker({
					lat: 40.748866,
					lng: -73.988366,
		            title: 'Loop, Inc.'
		        });
			});
        }

    };
}();