import { LightningElement } from 'lwc';
import { PAGES } from 'c/utils';

export default class Base extends LightningElement {
    
    handleRedirect(e) {
        this.redirectUserToPage(e.target.dataset.page);
    }

    redirectUserToPage(pageId) {
        this.setBrowserHistory(PAGES[pageId]);
        this.fireRedirectEvent(PAGES[pageId]);
    }

    handleMoveForward() {
        history.forward();
    }

    handleGoBack() {
        history.back();
    }

    setBrowserHistory(selectedPage) {
        let pageURLParam = '?page=' + selectedPage.id;
        history.pushState(selectedPage, selectedPage.title, pageURLParam);
    }

    fireRedirectEvent(selectedPage) {
        this.dispatchEvent(new CustomEvent('pagechange', { detail: selectedPage.id}));
    }

}