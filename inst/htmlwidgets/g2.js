HTMLWidgets.widget({

  name: 'g2',

  type: 'output',

  factory: function(el, width, height) {
    G2.track(false);
    
    var chart;
    
    return {

      renderValue: function(x) {
        
        x.container = x.container ? x.container : el.id;
        x.width = x.width ? x.width : width;
        x.height = x.height ? x.height : height;
        
        // convert data to array of row objects
        x.data = HTMLWidgets.dataframeToD3(x.data);
        
        // make sure that geoms is an array
        //  perhaps this is better done on the R side
        if(x.options.geoms && !Array.isArray(x.options.geoms)) {
          x.options.geoms = [x.options.geoms];
        }
        
        chart = new G2.Chart(x);
        chart.render();

      },

      resize: function(width, height) {

        // TODO: code to re-render the widget with a new size
        // this is easy since G2 has built-in resize

      }

    };
  }
});