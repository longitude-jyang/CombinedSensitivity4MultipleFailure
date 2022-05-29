# Combined Sensitivity for Multiple Failure Modes

This repository stores the codes to produce the results presented in the paper [Combined sensitivity analysis for multiple failure modes](https://doi.org/10.1016/j.cma.2022.115030), published in the journal of Computer Methods in Applied Mechanics and Engineering. 

With a given budget, a decision that designers have to make repetitively is to decide where to focus the limited resources on. Worse still, this decision has often to be made under large uncertainties. With applicaiton to reliability-based design, this work proposes a new metric for combined sensitivity of engineering systems that have multiple (correlated) failure modes. 

For a single failure mode, the failure probablity and its sensitivity can be estimated efficiently in a single run following these three steps: 

<img src="/docs/numericalFlowChart.png" height="80" width="700">

where the monte carlo based likelihood ratio method is used.  In case of a system failure mode with known failure configurations, the above procedure applies. However, it is generally difficult to knwo the 'failure configurations' as they can be correlated. 

Instead, it is proven in this paper that we can play a 'trick' and get the system failure sensitivity without explicit knowledge of the failure configurations. This is achived via a 'Sensitivity Matrix' where the failure sensitivity of individual modes are assembled:

$$\mathbf R = \begin{bmatrix}
\frac {\partial P_\text{f}^{(1)}}{\partial \mathbf b} & \frac {\partial P_\text{f}^{(2)}}{\partial \mathbf b} &\dots & \frac {\partial P_\text{f}^{(k)}}{\partial \mathbf b}
\end{bmatrix}$$

where the dominant singular vectors of the sensitivity matrix are found to indicate the most important parameters for combined sensitivity of multiple failure modes.

A demonstrator case study is presented in the paper with an offshore marine riser: 

<img src="/docs/marineriser.png" height="300" width="500">

where the riser is subject to a random wave excitation and its dynamic response is obtained using a linearised frequency domain model from the [CHAOS](https://github.com/longitude-jyang/hydro-suite) code. 

The results presented in the paper are based on 5000 Monte Carlo simulations. The MC data can be found [here](https://www.dropbox.com/s/h5apdcgymz4yzfc/MR_RS2_FATIGUE_N5000_11-06-2020%2008-26.mat?dl=0)


