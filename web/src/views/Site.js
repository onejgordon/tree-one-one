import Footer from '../components/Footer'
import TopBar from '../components/TopBar'
import { createTheme, ThemeProvider } from '@mui/material/styles';
import { Outlet, useOutletContext } from "react-router-dom";
import { SnackbarProvider } from 'notistack'
import AppConstants from '../config/AppConstants'

import '../App.css'

const muiTheme = createTheme({
  typography: {
    fontFamily: [
      '-apple-system',
      'BlinkMacSystemFont',
      '"Segoe UI"',
      'Roboto',
      '"Helvetica Neue"',
      'Arial',
      'sans-serif',
      '"Apple Color Emoji"',
      '"Segoe UI Emoji"',
      '"Segoe UI Symbol"',
    ].join(','),
    h3: {
      marginBottom: 20,
      marginTop: 20,
    }
  },
  palette: {
    primary: {
      main: AppConstants.PRIMARY_COLOR
    },
    danger: {
      main: "rgb(255, 0, 0)"
    }
  },
  components: {
    MuiCssBaseline: {
      styleOverrides: {
        body: {
          backgroundColor: "#EFEFEF",
        }
      }
    }
  }
});


export default function Site() {

  return (
        <ThemeProvider theme={muiTheme}>
          <SnackbarProvider>
            <Outlet context={{}} />
          </SnackbarProvider>
        </ThemeProvider>
    )
}

export function useMyTheme() {
  return useOutletContext();
}
