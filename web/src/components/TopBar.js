import { Box, CssBaseline, Toolbar, Typography } from '@mui/material';
import React from 'react';
import {useNavigate} from 'react-router-dom'
import NavBar from './NavBar';
import AppConstants from '../config/AppConstants'

const TopBar = () => {
  const navigate = useNavigate();
  
  return (
    <Box sx={{ flexGrow: 1 }}>
        <CssBaseline />
        <Toolbar style={styles.toolbar}>
            <img src="/logo.svg" 
              alt={AppConstants.SITENAME} 
              onClick={() => navigate("/")}
              style={styles.logo} width={25} />
            <Typography variant="h6" sx={{ flexGrow: 1, cursor: "pointer" }} onClick={() => navigate("/")}>
                { AppConstants.SITENAME }
            </Typography>
            <NavBar />
        </Toolbar>
    </Box>
  )
}

const styles = {
  logo: {
    marginRight: 15,
    cursor: "pointer"
  },
  toolbar: {
    color: 'white'
  }
}
export default TopBar