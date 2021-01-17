google.charts.load('current', {'packages':['gauge']});

/**
 * Populates the `planVizDiv` element with the plan visualization of the `finalState`.
 * @param {HTMLDivElement} planVizDiv host element on the page
 * @param {Plan} plan plan to be visualized
 * @param {{variableValue: string, value: number | boolean}[]} finalState final state of the `plan`
 * @param {number} displayWidth desired width in pixels
 */
function visualizeStateInDiv(planVizDiv, plan, finalState, displayWidth) {
  for (const v of finalState) {
    console.log(`${v.variableName}: ${v.value}`);
  }

  const valueMap = new Map(finalState.map(i => [i.variableName, i.value]));

  var data = google.visualization.arrayToDataTable([
    ['Label', 'Value'],
    ['water-temperature', valueMap.get('water-temperature')],
    ['cup-level',
      valueMap.get('cup-level')
      / valueMap.get('cup-capacity')
      * 100]
  ]);
  
  var options = {
    width: displayWidth, height: displayWidth,
    redFrom: 90, redTo: 100,
    yellowFrom: 75, yellowTo: 90,
    minorTicks: 5
  };

  var chart = new google.visualization.Gauge(planVizDiv);

  chart.draw(data, options);
}

module.exports = {
   visualizeStateInDiv: visualizeStateInDiv
};
