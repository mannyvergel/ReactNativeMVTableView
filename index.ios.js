/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 */
'use strict';

var React = require('react-native');
var {
  AppRegistry,
  View,
  Text,
  NavigatorIOS,
  TabBarIOS,
  ScrollView,
  StyleSheet,
} = React;

var MVTableView = require('./lib/MVTableView.ios.js');

var dummyData = [
]

for (var i =0; i<50; i++) {
  dummyData.push({title: 'My Title ' + (i+1), desc:'My description ' + (i+1)})
}

var SimpleTableView = React.createClass({
  render: function() {
    return (
      <View style={{flex: 1, marginTop: 64}}>
        <MVTableView getCellTemplate={this._getCellTemplate} 
              getDataForSectionRow={this._getDataForSectionRow} 
              appRegistry={AppRegistry} 
              getCellId={this._getCellId}
              numberOfRowsPerSection={[dummyData.length]}
              rowHeight={44}
              />
      </View>
    )
  },

  _getCellTemplate: function(sectionRow, data) {
    return 'MVTableViewCellTemplate';
  },

  _getDataForSectionRow: function(sectionRow) {
    return dummyData[sectionRow.row];
  },
})

var NavBarView = React.createClass({
  render: function() {
    return (
      <NavigatorIOS style={{flex: 1}} initialRoute={{title: 'MV Native UITableView', component: SimpleTableView}} 
      />
      )
  }
})


var MVTableViewCellTemplate = React.createClass({
  propTypes: {
    sectionRow: React.PropTypes.object,
    data: React.PropTypes.object,
  },

  render: function() {
    return  (
      <View style={{padding: 4, paddingLeft: 14}}>
        <Text style={{color: '#E8416F'}}>{this.props.data.title}</Text>
        <Text style={{color: '#808080'}}>{this.props.data.desc}</Text>
      </View>
    )
  }
});

AppRegistry.registerComponent('MVTableViewCellTemplate', () => MVTableViewCellTemplate);



AppRegistry.registerComponent('ReactNativeMVTableView', () => NavBarView);
