// Routes
import NotFound from '../components/NotFound'

import Home from '../views/Home'

import Site from '../views/Site';
import { Navigate } from 'react-router-dom'

export const routes = [
  {
    path: "/",
    element: <Site />,
    errorElement: <NotFound />,
    children: [
      {
        path: '',
        element: <Navigate to="/app" />,
      },
      {
        path: "app",
        element: <Home />,
      },
    ]
  },
  
]