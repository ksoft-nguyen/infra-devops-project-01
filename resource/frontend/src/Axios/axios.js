import axios from "axios"

const productionApiUrl = "https://api-final-project.nguyentrungkien.net/api"
const fallbackApiUrl = "http://3.95.18.142:8000/api"

const isLocalhost = (hostname) => {
    return hostname === "3.95.18.142" || hostname === "127.0.0.1" || hostname === "::1"
}

const getBaseURL = () => {
    const configuredApiUrl = process.env.REACT_APP_API_URL || fallbackApiUrl

    if (typeof window === "undefined" || window.location.protocol !== "https:") {
        return configuredApiUrl
    }

    try {
        const apiUrl = new URL(configuredApiUrl)

        if (apiUrl.protocol === "http:" && !isLocalhost(apiUrl.hostname)) {
            return productionApiUrl
        }
    } catch {
        return configuredApiUrl
    }

    return configuredApiUrl
}

const instance = axios.create({
    baseURL: getBaseURL()
})

export default instance
