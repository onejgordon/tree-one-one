import React, { useEffect, useState } from 'react';
import {Dialog, Container, Typography, DialogTitle, DialogContent, DialogActions, Button, Grid} from '@mui/material';
import { useNavigate } from 'react-router-dom';
import { useSnackbar } from 'notistack';
import AppConstants from '../config/AppConstants';
import TopBar from '../components/TopBar';
import Footer from '../components/Footer';


export default function Home() {
    const { enqueueSnackbar } = useSnackbar()
    const navigate = useNavigate()

    return (
        <div id="background" style={styles.background}>
            <div style={styles.foreground}>
                <Container maxWidth="lg">
                    <TopBar />
                    <Typography variant="h2" style={styles.tagline}>{ AppConstants.TAGLINE }</Typography>
                    <Typography variant="h3" style={styles.subhead}>
                        Learn about every tree in New York, thanks to the amazing <a href={AppConstants.NYC_DATASET_LINK} target="_blank">NYC Parks open datasets</a>.
                    </Typography>

                    <Grid container style={styles.main}>
                        <Grid md={6} align="center">
                            <img alt="Screenshot of TreeOneOne on iPhone" src="images/SplashScreen.png" width={300} />
                        </Grid>
                        <Grid md={6}>
                            <Typography variant="h3">How it works</Typography>
                            <ol style={styles.steps}>
                                <li>"Whoa, that's a beautiful tree"</li>
                                <li>Squint and think really hard</li>
                                <li>"Hmm... maybe it's a... Maple?"</li>
                                <li>Find out</li>
                            </ol>
                            <a href={AppConstants.APP_STORE_LINK} target="_blank"><img src="images/download-on-the-app-store.svg" width={200} /></a>
                        </Grid>
                    </Grid>
                </Container>
                <Footer />
            </div>
            <div id="mask" style={styles.mask}></div>
        </div>
    )
}

const styles = {
    background: {
        display: 'block',
        position: 'absolute',
        left: 0,
        right: 0,
        top: 0,
        bottom: 0,
        width: '100%',
        height: '100%',
        background: "url(/images/seward.jpg) 50% 50%",
        backgroundSize: 'cover'
    },
    mask: {
        display: 'block',
        position: 'absolute',
        left: 0,
        right: 0,
        top: 0,
        bottom: 0,
        width: '100%',
        height: '100%',
        background: 'rgba(0,0,0,0.6)',
        zIndex: 1,
    },
    foreground: {
        color: "white",
        display: 'block',
        position: 'absolute',
        left: 0,
        right: 0,
        top: 0,
        bottom: 0,
        width: '100%',
        height: '100%',
        zIndex: 10,
    },
    steps: {
        fontSize: '2em'
    },
    tagline: {
        fontSize: '4em',
        color: 'white',
        maxWidth: "600px"
    },
    subhead: {
        fontSize: '2em',
        maxWidth: "600px"
    },
    main: {
        marginTop: 100
    }
}