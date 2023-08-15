import React from 'react';
import AppConstants from '../config/AppConstants'
import { Box, Typography } from '@mui/material';

export default function Footer({ theme }) {

  var YEAR = new Date().getFullYear();
  let year_text;
  if (AppConstants.YEAR != YEAR) year_text = <span>&copy; { AppConstants.YEAR } - { YEAR } { AppConstants.SITENAME }</span>
  else year_text = <span>&copy; { YEAR } { AppConstants.SITENAME }</span>
  return (
    <Box style={styles.footer}>
        <Typography align="center">{ year_text } | Free and Open Source Software</Typography>
        <Typography align="center" style={styles.subhead}>Also check out the official <a href={AppConstants.NYC_TREE_MAP_LINK} target="_blank">NYC Tree Map</a> (best in a browser)</Typography>
    </Box>
  )
}


const styles = {
  footer: {
    position: "absolute",
    bottom: 0,
    left: 0,
    right: 0,
    color: "#999",
    padding: 20
  },
  subhead: {
    fontSize: "0.8em"
  }
}