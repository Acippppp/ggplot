from datetime import datetime
import backtrader as bt
import backtrader.indicators as btind
import argparse

'''
class SmaCross(bt.SignalStrategy):
    def __init__(self):
        sma1, sma2 = bt.ind.SMA(period=10), bt.ind.SMA(period=30)
        crossover = bt.ind.CrossOver(sma1, sma2)
        self.signal_add(bt.SIGNAL_LONG, crossover)

cerebro = bt.Cerebro()
cerebro.addstrategy(SmaCross)

data0 = bt.feeds.YahooFinanceData(dataname='TSLA', fromdate=datetime(2012, 1, 1),
                                  todate=datetime(2021, 7, 2))
cerebro.adddata(data0)

cerebro.run()
cerebro.plot()



class StochRSI(bt.SignalStrategy):
    lines = ('stochrsi',)
    params = dict(
        period=14,  # to apply to RSI
        pperiod=None,  # if passed apply to HighestN/LowestN, else "period"
    )

    def __init__(self):
        rsi = bt.ind.RSI(self.data0, period=self.p.period)

        pperiod = self.p.pperiod or self.p.period
        maxrsi = bt.ind.Highest(rsi, period=pperiod)
        minrsi = bt.ind.Lowest(rsi, period=pperiod)

        self.l.stochrsi = (rsi - minrsi) / (maxrsi - minrsi)
        
'''





'''
#Instantiate Cerebro engine
cerebro = bt.Cerebro(stdstats=False)

#Set data parameters and add to Cerebro
data1 = bt.feeds.YahooFinanceData(
    dataname='5195.KL',
    fromdate=datetime(2021, 1, 1),
    todate=datetime(2021, 6, 25))
cerebro.adddata(data1)

data2 = bt.feeds.YahooFinanceData(
    dataname='5040.KL',
    fromdate=datetime(2021, 1, 1),
    todate=datetime(2021, 6, 25))

data2.compensate(data1)  # let the system know ops on data1 affect data0
data2.plotinfo.plotmaster = data1
data2.plotinfo.sameaxis = True
cerebro.adddata(data2)

#Run Cerebro Engine
cerebro.run()
cerebro.plot()
'''

class PlotStrategy(bt.Strategy):
    '''
    #The strategy does nothing but create indicators for plotting purposes
'''
    params = dict(
        smasubplot=False,  # default for Moving averages
        nomacdplot=False,
        rsioverstoc=False,
        rsioversma=False,
        stocrsi=False,
        stocrsilabels=False,
    )

    def __init__(self):
        sma = btind.SMA(subplot=self.params.smasubplot)

        macd = btind.MACD()
        # In SMA we passed plot directly as kwarg, here the plotinfo.plot
        # attribute is changed - same effect
        macd.plotinfo.plot = not self.params.nomacdplot

        # Let's put rsi on stochastic/sma or the other way round
        stoc = btind.Stochastic()
        rsi = btind.RSI()
        if self.params.stocrsi:
            stoc.plotinfo.plotmaster = rsi
            stoc.plotinfo.plotlinelabels = self.p.stocrsilabels
        elif self.params.rsioverstoc:
            rsi.plotinfo.plotmaster = stoc
        elif self.params.rsioversma:
            rsi.plotinfo.plotmaster = sma


def runstrategy():
    args = parse_args()

    # Create a cerebro
    cerebro = bt.Cerebro()

    # Get the dates from the args
    #fromdate = datetime.datetime.strptime(args.fromdate, '%Y-%m-%d')
    #todate = datetime.datetime.strptime(args.todate, '%Y-%m-%d')

    # Create the 1st data
    data0 = bt.feeds.YahooFinanceData(dataname='5195.KL', fromdate=datetime(2021, 1, 1),
                                      todate=datetime(2021, 6, 30))
    # Add the 1st data to cerebro
    cerebro.adddata(data0)

    # Add the strategy
    cerebro.addstrategy(PlotStrategy,
                        smasubplot=args.smasubplot,
                        nomacdplot=args.nomacdplot,
                        rsioverstoc=args.rsioverstoc,
                        rsioversma=args.rsioversma,
                        stocrsi=args.stocrsi,
                        stocrsilabels=args.stocrsilabels)

    # And run it
    cerebro.run(stdstats=args.stdstats)

    # Plot
    cerebro.plot(numfigs=args.numfigs, volume=False)

def parse_args():
    parser = argparse.ArgumentParser(description='Plotting Example')

    parser.add_argument('--data', '-d',
                        default='../../datas/2006-day-001.txt',
                        help='data to add to the system')

    parser.add_argument('--fromdate', '-f',
                        default='2006-01-01',
                        help='Starting date in YYYY-MM-DD format')

    parser.add_argument('--todate', '-t',
                        default='2006-12-31',
                        help='Starting date in YYYY-MM-DD format')

    parser.add_argument('--stdstats', '-st', action='store_true',
                        help='Show standard observers')

    parser.add_argument('--smasubplot', '-ss', action='store_true',
                        help='Put SMA on own subplot/axis')

    parser.add_argument('--nomacdplot', '-nm', action='store_true',
                        help='Hide the indicator from the plot')

    group = parser.add_mutually_exclusive_group(required=False)

    group.add_argument('--rsioverstoc', '-ros', action='store_true',
                       help='Plot the RSI indicator on the Stochastic axis')

    group.add_argument('--rsioversma', '-rom', action='store_true',
                       help='Plot the RSI indicator on the SMA axis')

    group.add_argument('--stocrsi', '-strsi', action='store_true',
                       help='Plot the Stochastic indicator on the RSI axis')

    parser.add_argument('--stocrsilabels', action='store_true',
                        help='Plot line names instead of indicator name')

    parser.add_argument('--numfigs', '-n', default=1,
                        help='Plot using numfigs figures')

    return parser.parse_args()


if __name__ == '__main__':
    runstrategy()
