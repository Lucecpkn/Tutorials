import pandas as pd


def some_calculation(df, coeff):
    target = sum([i**coeff for i in df.iloc[:, 1]])
    return target

if __name__ == "__main__":
    df = pd.read_csv('sample_data.csv')
    
    for i in range(1, 11):
      print("coeff = ", i)
      print(some_calculation(df, i))