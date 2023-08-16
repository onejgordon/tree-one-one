# TreeOneOne

## Data Sources

We use two NY Parks & Rec open datasets:

* [NYC Parks 2015 Tree Census](https://data.cityofnewyork.us/Environment/2015-Street-Tree-Census-Tree-Data/pi5s-9p35)
* [Forestry Tree Points](https://data.cityofnewyork.us/Environment/Forestry-Tree-Points/hn5i-inap)

## Developing

### NYC Open Data access

To use the open data APIs, register for a free account at [https://data.cityofnewyork.us/](https://data.cityofnewyork.us/).

Create an app token in your [developer settings](https://data.cityofnewyork.us/profile/edit/developer_settings) dashboard.

### Setup iOS

Create a `Config.xcconfig` in `TreeOneOne/Settings` which defines the following variables:

- `NYC_PARKS_TREE_API_APP_TOKEN` (with your app token created above)

You should now be able to run the app in Xcode in a simulator.

## Help

Run into issues?

Send a message through the contact page [here](https://jgordon.io/contact).