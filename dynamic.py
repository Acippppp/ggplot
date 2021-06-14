import requests
from bs4 import BeautifulSoup as bs
from urllib.request import urlopen
import pandas as pd
import time
import datetime
month = ['01','02','03','04','05','06','07','08','09','10','11','12']
day = ['01','02','03','04','05','06','07','08','09','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25','26','27','28','29','30','31']
#day = 18

start_time = time.time()
list_of_data = []
for j in range(0,13):
    for i in range(0, 32):
        try:
            time.sleep(5)
            html = urlopen('https://sdvi2.fama.gov.my/price/direct/price/daily_commodityRpt.asp?Pricing=A&LevelCd=03&PricingDt=2012/'+ month[j]+'/' + day[i])
            soup = bs(html, 'lxml')
            soup = soup.findAll('tr')[4]
            if 'TIADA MAKLUMAT LAPORAN PADA CARIAN ANDA.' in soup.text:
                print('Table is not in the data ', day[i], month[j])
                print(soup)
            else:
                print('Table is in the data  '+ day[i]+ '/'+ month[j]+ '/2012')
                soup = soup.findAll('tr')
                list_of_runcit = []
                for row in soup:
                    each_row = row.findAll('td')
                    str_row = str(each_row)
                    row_text = bs(str_row,'lxml').get_text()
                    list_of_runcit.append(row_text)
                print(list_of_runcit)
                data = pd.DataFrame(list_of_runcit[0:])
                data = data[0].str.split(",",expand = True)
                data = data.rename(columns = {0:'Nama_Variety',1:'Gred',2:'Unit',3:'Harga_Tinggi',4:'Harga_Purata',5:'Harga_Rendah'})
                Tarikh =datetime.date(2012,j+1,i+1)
                x = [Tarikh] * len(data)
                data['Tarikh'] = x
                data = data.values.tolist()
                list_of_data.extend(data)




        except Exception as e:
            print(e)

data = pd.DataFrame(list_of_data[0:])

data = data.rename(columns={0: 'Nama_Variety', 1: 'Gred', 2: 'Unit', 3: 'Harga_Tinggi', 4: 'Harga_Purata', 5: 'Harga_Rendah', 6:'Tarikh'})
data['Nama_Variety'] = data['Nama_Variety'].str.replace('[','')
data['Harga_Rendah'] = data['Harga_Rendah'].str.replace(']','')
print(data)
print("--- %s seconds ---" % (time.time() - start_time))
data.to_csv(r'C:\Users\Hp\Documents\2014.csv', encoding='utf-8', index=False)

