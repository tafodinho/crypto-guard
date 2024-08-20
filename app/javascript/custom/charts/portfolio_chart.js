document.addEventListener("turbo:load", function () {
  const portfolioDataId = document.getElementById(`portfolio-data`);
  const portfolioData = JSON.parse(portfolioDataId.dataset.portfolioData);

  const getChartOptions = (series, labels) => {
    return {
      series,
      chart: {
        height: 280,
        width: "100%",
        type: "donut",
      },
      stroke: {
        colors: ["transparent"],
        lineCap: "",
      },
      plotOptions: {
        pie: {
          donut: {
            labels: {
              show: true,
              name: {
                show: true,
                fontFamily: "Inter, sans-serif",
                offsetY: 20,
                font: 30,
              },
              // total: {
              //   showAlways: true,
              //   show: true,
              //   label: "BTC",
              //   fontFamily: "Inter, sans-serif",
              //   formatter: function (w) {
              //     console.log("w", w);
              //     const sum = w.globals.seriesTotals.reduce((a, b) => {
              //       return a + b;
              //     }, 0);
              //     return sum.toFixed(2) + "%";
              //   },
              // },
              value: {
                show: true,
                fontFamily: "Inter, sans-serif",
                offsetY: -20,
                formatter: function (value) {
                  return value + "%";
                },
              },
            },
            size: "70%",
          },
        },
      },
      grid: {
        padding: {
          top: -2,
        },
      },
      labels,
      dataLabels: {
        enabled: false,
      },
      legend: {
        position: "bottom",
        fontFamily: "Inter, sans-serif",
        height: 40,
      },
      yaxis: {
        labels: {
          formatter: function (value) {
            return value + "%";
          },
        },
      },
      xaxis: {
        labels: {
          formatter: function (value) {
            return value + "k";
          },
        },
        axisTicks: {
          show: true,
        },
        axisBorder: {
          show: true,
        },
      },
    };
  };

  portfolioData.forEach((data, index) => {
    const chartDom = document.getElementById(`portfolio-chart-${index}`);
    const chartData = JSON.parse(chartDom.dataset.portfolioHoldings);
    const coinSymbols = chartData.map((entry) => entry.coin_symbol);
    const coinWeights = chartData.map((entry) =>
      parseFloat(parseFloat(entry.target_percentage).toFixed(2))
    );
    console.log(coinWeights);
    if (chartDom && typeof ApexCharts !== "undefined") {
      const chart = new ApexCharts(
        chartDom,
        getChartOptions(coinWeights, coinSymbols)
      );

      chart.render();
    }
  });

  function hyphenateString(str) {
    // Trim leading and trailing whitespace
    let trimmedStr = str.trim();

    // Replace spaces and underscores with hyphens
    let hyphenatedStr = trimmedStr.replace(/\s+/g, "-").replace(/_/g, "-");

    // Convert to lowercase for consistency
    return hyphenatedStr.toLowerCase();
  }
});
