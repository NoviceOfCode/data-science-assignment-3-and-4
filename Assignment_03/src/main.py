import dash
from dash import dcc, html, Input, Output
import pandas as pd
import plotly.express as px

# Fetch the CSV data
filename = "../data_clean/card_info.csv"

# Load the data into a DataFrame
df = pd.read_csv(filename)

# Create Dash app
app = dash.Dash(__name__)

# Define layout
app.layout = html.Div([
    html.H1("Yu-Gi-Oh! Card Price Analysis"),
    dcc.Dropdown(
        id='type-dropdown',
        options=[{'label': i, 'value': i} for i in df['type'].unique()],
        value='Spell Card',
        clearable=False
    ),
    dcc.Graph(id='scatter-plot')
])

# Define callback to update scatter plot based on selected card type
@app.callback(
    Output('scatter-plot', 'figure'),
    [Input('type-dropdown', 'value')]
)
def update_scatter_plot(selected_type):
    filtered_df = df[df['type'] == selected_type]
    fig = px.scatter(filtered_df, x='cardmarket_price', y='tcgplayer_price',
                     color='cardmarket_price', color_continuous_scale='Viridis',
                     labels={'cardmarket_price': 'Cardmarket Price', 'tcgplayer_price': 'TCGplayer Price'},
                     title=f'Scatter Plot of Card Prices for {selected_type} Cards')
    fig.update_layout(xaxis=dict(type='log'), yaxis=dict(type='log'))  # Log scale for better visualization of price distribution
    return fig

# Run the app
if __name__ == '__main__':
    app.run_server(debug=True)
