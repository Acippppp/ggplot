import pandas as pd



df15 = pd.read_csv('C:/Users/Hp/Documents/Runcit/2015.csv')
df16 = pd.read_csv('C:/Users/Hp/Documents/Runcit/2016.csv')
df17 = pd.read_csv('C:/Users/Hp/Documents/Runcit/2017.csv')
df18 = pd.read_csv('C:/Users/Hp/Documents/Runcit/2018.csv')
df19 = pd.read_csv('C:/Users/Hp/Documents/Runcit/2019.csv')
df20 = pd.read_csv('C:/Users/Hp/Documents/Runcit/2020.csv')
df21 = pd.read_csv('C:/Users/Hp/Documents/Runcit/2021.csv')
print(df15)

all = pd.concat([df15,df16,df17,df18,df19,df20,df21],ignore_index=True)
print(all)
list_all = all['Nama_Variety'].tolist()
print(list_all)

x= 'Pusat'
for i in range(0,len(list_all)):
  if x in list_all[i]:
    list_all[i] = list_all[i]
  else:
    list_all[i] = list_all[i-1]
print(list_all)

negeri = all['Gred'].tolist()
y = ']'
for j in range(0,len(negeri)):
  if y in negeri[j]:
    negeri[j] = negeri[j]
  else:
    negeri[j] = negeri[j-1]
print(negeri)


all['Pusat'] =list_all
all['Negeri'] = negeri
all = all.dropna()
all['Pusat'] = all['Pusat'].str.replace('Pusat : ','')
all['Negeri'] = all['Negeri'].str.replace(']','')

print(all)
all.to_csv(r'C:\Users\Hp\Documents\all.csv', encoding='utf-8', index=False)















