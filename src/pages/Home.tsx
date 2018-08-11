import * as React from 'react';
import { css,StyleSheet,minify } from 'aphrodite';
import Navbar from '../views/Navbar';
import Search from 'src/views/Search';

minify(false);

class Home extends React.Component {
  public render() {
    return (
      <div id="div_page" className={css(styles.page)} >
        
        <div id="div_header" className={css(styles.header)} >
          <Navbar/>
        </div>

        <div id="div_body" className={css(styles.body)} >
          <div id="div_search_container" className={css(styles.searchContainer)} >
            <div id="div_title" className={css(styles.title)} >
              iPTMnet
            </div> 
            <div id="div_grant_container" className={css(styles.grantContainer)} >
              
              <div id="div_nsf_label">
                NSF Grants
              </div>

              <a href="#" className={css(styles.grant1)} >
                  ABI-1062520
              </a>

              <a href="http://nsf.gov/awardsearch/showAward.do?AwardNumber=1062520" 
                 target="_" 
                 className={css(styles.grant1)} >
                  U01GM120953
              </a>

            </div>

            <Search />
                                  

          </div>
        </div>
                 
      </div>
    );
  }
}

const styles = StyleSheet.create({
  page : {
    minHeight: "100%",
    display: "flex",
    flexDirection: "column",
    alignItems: "center",
    flex: "1",
    backgroundColor: "#ffffffff"
  },

  header : {
    display: "flex",
    flexDirection: "column",
    alignSelf: "stretch"
  },

  body: {
    display: "flex",
    flexDirection: "column",
    alignItems: "center",
    "flex-grow": "1",
    paddingTop: "20",
    overflow: "auto"
  },

  searchContainer : {
    display: "flex",
    flexDirection: "column",
    alignItems: "center",
    paddingTop: 100,
    paddingBottom: 100
  },

  title : {
    fontSize: "5em",
    marginTop: "0.1em"
  },

  grantContainer : {
    marginTop: 5,
    display: "flex",
    flexDirection: "row",
    alignItems: "center",
    fontSize: "1em"
  },

  grant1 : {
    marginLeft: 10,
    fontSize: "0.85em",
    
    ":link": {
        color: "#329CDA"
    },
    
    ":visited": {
        color: "#329CDA"
    }
  },

  


});

export default Home;
