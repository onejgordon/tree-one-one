import React from 'react';
import { Link, useLocation, useNavigate } from 'react-router-dom';
import { Avatar, Button, Divider, ListItemIcon, MenuItem } from '@mui/material';

function NavBar({ page }) {

  const navigate = useNavigate()

  const COMMON_MENU = [
  ]

  let menu = COMMON_MENU;

  return (
    <div className="NavBar">
        { menu.map((mi, i) => {
          let cls = ""
          return <Button onClick={() => navigate(mi.to || mi.id)} className={cls} color="inherit" key={i}>{mi.name}</Button>
        })}
    </div>
  )
}


export default NavBar