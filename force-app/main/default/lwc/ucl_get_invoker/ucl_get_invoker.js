import { LightningElement } from 'lwc';
import invoke_get_call from '@salesforce/apex/ucl_getInvokerController.invoke_get_call';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ButtonBasic extends LightningElement {

    handleClick(event) {
        invoke_get_call({})
            .then(success => {
                console.log('success: ', success)
                const evt = new ShowToastEvent({
                    title: 'Toast Success',
                    message: 'Operation sucessful',
                    variant: 'success',
                    mode: 'sticky'
                });
                this.dispatchEvent(evt);

            })
            .catch(error => {
                console.log('ERROR OCURRED')

                console.log(error)

                const evt = new ShowToastEvent({
                    title: 'Toast Error',
                    message: 'An error ocurred: ${error}',
                    variant: 'error',
                    mode: 'sticky'
                });
                this.dispatchEvent(evt);            
            });
    }
}