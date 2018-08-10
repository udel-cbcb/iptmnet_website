import * as React from 'react';
import Navbar from '../views/Navbar';
import { InfoConnected } from '../views/Info';

interface IEntryProps {
  id: string;
}

class Entry extends React.Component<IEntryProps,{}> {

  constructor(props: IEntryProps) {
    super(props);
  }

  public render() {
    return (
      <div>
        <Navbar/>
        <div>
          <InfoConnected/>  
        </div> 
      </div>
    );
  }
}

export default Entry;