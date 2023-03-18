/**
 * https://docs.github.com/en/actions/learn-github-actions/environment-variables
 */
import { IServiceParams, UploaderEnvs, UploaderInputs } from '../types';
export declare function detect(envs: UploaderEnvs): boolean;
export declare function getServiceName(): string;
export declare function getServiceParams(inputs: UploaderInputs): IServiceParams;
export declare function getEnvVarNames(): string[];
