import React, {  } from 'react';
import {Container, Typography, Grid} from '@mui/material';
import { useNavigate } from 'react-router-dom';
import { useSnackbar } from 'notistack';
import AppConstants from '../config/AppConstants';
import TopBar from '../components/TopBar';
import Footer from '../components/Footer';
import { useMediaQuery } from 'react-responsive';


export default function Home() {
    const { enqueueSnackbar } = useSnackbar()
    const navigate = useNavigate()
    const isSmallScreen = useMediaQuery({
        query: '(max-width: 768px)'
    });

    const subSplashContent = (
        <div className="subSplashContent">
            <Grid container style={styles.main}>
                <Grid item xs={12} sm={12} md={6} align="center">
                    <img alt="Screenshot of TreeOneOne on iPhone" src="images/SplashScreen.png" width={300} />
                </Grid>
                <Grid item xs={12} sm={12} md={6}>
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
            <Footer />
        </div>
)

    return (
        <div id="home" className="splash">
            <div className="foreground">
                <Container maxWidth="lg">
                    <TopBar />
                    <Typography variant="h2" style={styles.tagline}>{ AppConstants.TAGLINE }</Typography>
                    <Typography variant="h3" style={styles.subhead}>
                        Learn about every tree in New York, thanks to the amazing <a href={AppConstants.NYC_DATASET_LINK} target="_blank">NYC Parks open datasets</a>.
                    </Typography>

                    { !isSmallScreen ? subSplashContent : null }                    
                </Container>
            </div>
            <div className="mask"></div>
            { isSmallScreen ? subSplashContent : null }
        </div>
    )
}

const styles = {
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