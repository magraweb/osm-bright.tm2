
// =====================================================================
// LABELS

// General notes:
// - `text-halo-rasterizer: fast;` gives a noticeable performance
//    boost to render times and is recommended for *all* halos.

// ---------------------------------------------------------------------
// Languages

// There are 5 language options in the MapBox Streets vector tiles:
// - Local/default: '[name]'
// - English: '[name_en]'
// - French: '[name_fr]'
// - Spanish: '[name_es]'
// - German: '[name_de]'
@name: '[name]';  


// ---------------------------------------------------------------------
// Fonts

// All fontsets should have a good fallback that covers as many glyphs
// as possible. 'Arial Unicode MS Regular' and 'Arial Unicode MS Bold' 
//are recommended as final fallbacks if you have them available. 
//They support all the characters used in the MapBox Streets vector tiles.

@fallback: 'Arial Unicode MS Regular';
@sans: 'Segoe UI Light', @fallback;
@sans_md: 'Segoe UI Semilight', @fallback;
@sans_bd: 'Segoe UI Semibold', @fallback;
@sans_it: 'Segoe UI Light Italic', @fallback;

/*
@fallback: 'Source Sans Pro Regular';		
@sans: 'Source Sans Pro Regular', @fallback;		
@sans_md: 'Source Sans Pro Semibold', @fallback;		
@sans_bd: 'Source Sans Pro Bold', @fallback;		
@sans_it: 'Source Sans Pro Italic', @fallback;
*/

#country_label_line {
  // Lines that connect offset labels to small
  // island & coastal countries at small scales.
  line-color: #334;
  line-opacity: 0.5;
}

// ---------------------------------------------------------------------
// Marine

#marine_label {
  text-name: @name;
  text-face-name: @sans_it;
  text-wrap-width: 60;
  text-wrap-before: true;
  text-fill: darken(@water, 10);
  text-halo-fill: fadeout(#fff, 75%);
  text-halo-radius: 1.5;
  text-size: 10;
  text-character-spacing: 1;
  // Some marine labels should be drawn along a line 
  // rather than on a point (the default)
  [placement='line'] {
    text-placement: line;
    text-avoid-edges: true;
  }
  // Oceans
  [labelrank=1] { 
    text-size: 18;
    text-wrap-width: 120;
    text-character-spacing:	4;
    text-line-spacing:	8;
  }
  [labelrank=2] {
    text-size: 14;
  }
  [labelrank=3] {
    text-size: 11;
  }
  [zoom>=5] {
    text-size: 12;
    [labelrank=1] {
      text-size: 22;
     }
    [labelrank=2] {
      text-size: 16;
     }
    [labelrank=3] {
      text-size: 14;
      text-character-spacing: 2;
     }
   }
}

// ---------------------------------------------------------------------
// Cities, towns, villages, etc
// City labels with dots for low zoom levels.
// The separate attachment keeps the size of the XML down.
#place_label::citydots[type='city'][zoom>=4][zoom<=7] {
  // explicitly defining all the `ldir` values wer'e going
  // to use shaves a bit off the final project.xml size
  [ldir='N'],[ldir='S'],[ldir='E'],[ldir='W'],
  [ldir='NE'],[ldir='SE'],[ldir='SW'],[ldir='NW'] {
    marker-width: 5;
    marker-fill: @lavanda2;
    marker-opacity: .5;
    marker-line-width: 0;
  }
}

#place_label[zoom>=8] {
  text-character-spacing: 1.4;
  text-name: @name;
  text-face-name: @sans;
  text-wrap-width: 120;
  text-wrap-before: true;
  text-halo-fill: fadeout(@land, 50%);
  text-halo-radius: 1.8;
  text-halo-rasterizer: fast;
  text-fill: @lavanda2;  
  [type='city'][zoom>=8][zoom<=15] {
  	text-face-name: @sans_md;
    text-transform: uppercase;
    text-size: 13;
    [zoom>=10] { 
      text-size: 15;
      text-wrap-width: 140;
    }
    [zoom>=12] { 
      text-size: 20;
      text-wrap-width: 180;
    }
    // Hide at largest scales:
    [zoom>=16] { text-name: "''"; }
  }
  [type='town'] {
    text-size: 13;
    [zoom>=12] { text-size: 14; }
    [zoom>=14] { text-size: 18; }
    [zoom>=16] { text-size: 22; }
    // Hide at largest scales:
    [zoom>=18] { text-name: "''"; }
  }
  [type='village'] {
    text-size: 12;
    text-fill: @maroon1;
    [zoom>=12] { text-size: 14; }
    [zoom>=14] { text-size: 18; }
    [zoom>=16] { text-size: 22; }
  }
  [type='hamlet'],
  [type='suburb'],
  [type='neighbourhood'] {
    text-fill: @maroon1;
    text-face-name:	@sans_bd;
    text-transform: uppercase;
    text-character-spacing: 0.5;
    [zoom<13] {text-name: "''"; }
    [zoom>=14] { text-size: 11; }
    [zoom>=15] { text-size: 12; text-character-spacing: 1; }
    [zoom>=16] { text-size: 14; text-character-spacing: 2; }
  }
}


// ---------------------------------------------------------------------
// Points of interest
#poi_label {
  
  [type='Rail Station'],
  [type='University'],
  [type='College'],  
  [type='School'],  
  [type='Place Of Worship'],
  [type='Hospital'],
  [type='Museum'],  
  [type='Park'],  
  [type='Police'],   
  [type='Townhall'],     
  {
    
    [zoom=14][scalerank<=1],
    [zoom=15][scalerank<=2],
    [zoom=16][scalerank<=3],
    [zoom=17][scalerank<=4][localrank<=2],
    [zoom>=18] {
      // Separate icon and label attachments are created to ensure that
      // all icon placement happens first, then labels are placed only
      // if there is still room.
      ::icon[maki!=null] {
        // The [maki] field values match a subset of Maki icon names, so we
        // can use that in our url expression.
        // Not all POIs have a Maki icon assigned, so we limit this section
        // to those that do. See also <https://www.mapbox.com/maki/>
        //point-fill:@maroon2;
        point-file:url('icon/[maki]-12.svg');
        point-comp-op: hard-light;
      }
      ::label {
        text-name: @name;
        text-face-name: @sans_it;
        text-size: 12;
        text-fill: @maroon1;
        text-halo-fill: @land;
        text-halo-radius: 1;
        text-halo-rasterizer: fast;
        text-wrap-width: 70;
        text-line-spacing:	-1;
        //text-transform: uppercase;
        //text-character-spacing:	0.25;
        // POI labels with an icon need to be offset:
        [maki!=null] { text-dy: 8; }
      }
    }
  }
}

// ---------------------------------------------------------------------
// Roads

#road_label[reflen>=1][reflen<=6]::shield {
  // Motorways with a 'ref' tag that is 1-6 characters long have a
  // [ref] value for shield-style labels.
  // Custom shield png files can be created using make_shields.sh
  // in _src folder
  shield-name: [ref];
  shield-face-name: @sans_bd;
  shield-fill: #765;
  shield-min-distance: 60;
  shield-size: 9;
  shield-file: url('img/motorway_sm_[reflen].png');
  [zoom>=15] {
    shield-size: 11;
    shield-file: url('img/motorway_lg_[reflen].png');
  }
}

#road_label {
  // You need to use [name] for road labels if you want English street
  // prefixes and suffixes to be abbreviated. Translated labels do not
  // have abbreviations.
  text-name: [name];
  text-placement: line;  // text follows line path
  text-face-name: @sans;
  text-fill: @maroon1;
  text-halo-fill: @road_small;
  text-halo-radius: 1;
  text-halo-rasterizer: fast;
  text-size: 12;
  [zoom<15][class='street'] { text-name: "''"; }
  [zoom<16][class='service'], [zoom<16][class='path'] { text-name: "''"; }
  [zoom>=15] { text-size: 13; }
}


// ---------------------------------------------------------------------
// Water

#water_label {
  [zoom<=13],  // automatic area filtering @ low zooms
  [zoom>=14][area>500000],
  [zoom>=16][area>10000],
  [zoom>=17] {
    text-name: @name;
    text-face-name: @sans_it;
    text-fill: darken(@water, 15);
    text-size: 12;
    text-wrap-width: 100;
    text-wrap-before: true;
    text-halo-fill: fadeout(#fff, 75%);
    text-halo-radius: 1.5;
  }
}
