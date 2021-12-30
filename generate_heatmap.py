import seaborn as sns
import pandas as pd
from matplotlib import pyplot as plt

### Create a heatmap using calculated z-scores of miRNA ###

data = 'values>5rpm.csv'
#data = 'above_1rpm_unannot.csv'
#data = 'file2.csv'
df = pd.read_csv(data)
df = df.set_index('miRNA')
del df.index.name
#df
print df
#sns.clustermap(df, zscore=1)
#sns.clustermap(df, metric="correlation")
sns.clustermap(df, metric="correlation", method="single", yticklabels=True)
plt.show()
