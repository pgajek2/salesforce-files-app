import { LightningElement, track } from 'lwc';
import { PAGES } from 'c/utils';

const DEFAULT_PAGE = PAGES.A.id;

export default class Container extends LightningElement {

    @track currentPage;

    constructor() {
        super();
        //Page refresh
        this.currentPage = this.getPageParamFromUrl();
        //JS History changes listner - go, back
        window.onpopstate = (event) => {
            this.currentPage = event.state && event.state.id ? event.state.id : DEFAULT_PAGE;
        }
    }

    handleChildComponentsRedirection(e) {
        this.currentPage = e.detail;
    }
    
    get isPageA() {
        return this.checkIfIsCurrentPage(PAGES.A.id);
    }

    get isPageB() {
        return this.checkIfIsCurrentPage(PAGES.B.id);
    }

    get isPageC() {
        return this.checkIfIsCurrentPage(PAGES.C.id);
    }

    checkIfIsCurrentPage(pageId) {
        return this.currentPage === pageId;
    }

    getPageParamFromUrl() {
        let urlPageId = new URL(window.location.href).searchParams.get("page");
        if (urlPageId && PAGES[urlPageId]) {
            return urlPageId;
        }
        return  DEFAULT_PAGE;
    }
}