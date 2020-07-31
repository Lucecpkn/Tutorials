import pandas as pd
import sys  # to get system variables


coeff = int(sys.argv[1])

def some_calculation(df, coeff: int):
    target = sum([i**coeff for i in df.iloc[:, 1]])
    return target

if __name__ == "__main__":
    df = pd.read_csv('sample_data.csv')
    print("coeff = ", coeff)
    print(some_calculation(df, coeff))